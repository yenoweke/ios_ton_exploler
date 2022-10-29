import Foundation
import UIKit
import TonTransactionsKit

public protocol Router: AnyObject {
    var topRouter: Router { get }
    var nextRouter: Router? { get }

//    func show(_ alert: Alert)
    func show(_ coordinator: BaseCoordinator, style: PresentationStyle, animated: Bool, completion: VoidClosure?)
    func show(_ context: RouterTransitionContext)
    func push(_ container: ModuleContainer, completion: VoidClosure?)
    func present(_ container: ModuleContainer, navigationControllerConfig: NavigationControllerConfig?, withCloseButton: Bool, animated: Bool, completion: VoidClosure?)
    func dismissActiveItem(animated: Bool, completion: VoidClosure?)
//    func makeBusy() -> BusyIndicator?

    func set(rootViewController: UIViewController)
}

public extension Router {
    func push(_ container: ModuleContainer) {
        self.push(container, completion: nil)
    }

    func push(_ container: ModuleContainer, completion: VoidClosure?) {
        let context = RouterTransitionContext(container: container, style: .push, animated: true, completion: completion)
        self.show(context)
    }

    func present(_ container: ModuleContainer, navigationControllerConfig: NavigationControllerConfig? = nil, withCloseButton: Bool = false, animated: Bool = true, completion: VoidClosure? = nil) {
        let context = RouterTransitionContext(container: container, style: .present(navigationControllerConfig: navigationControllerConfig, withCloseButton: withCloseButton), animated: animated, completion: completion)
        self.show(context)
    }
}

enum Routing {
    enum ItemType {
        case router(holder: RouterHolder)
        case coordinator(BaseCoordinator)
    }

    struct Item {
        let itemType: ItemType
        let presentationStyle: PresentationStyle

        var isValid: Bool {
            switch self.itemType {
            case .router(let holder):
                return holder.router != nil
            case .coordinator(let coordinator):
                return coordinator.rootRouter != nil
            }
        }

        var router: Router? {
            switch self.itemType {
            case .router(let holder):
                return holder.router
            case .coordinator(let coordinator):
                return coordinator.rootRouter
            }
        }
    }
}

final class RouterHolder {
    weak var router: Router?

    init(_ router: Router?) {
        self.router = router
    }
}

open class BaseRouter: Router {
    public var navigationControllerProvider: (() -> UINavigationController?)?
    public var presentingViewControllerProvider: (() -> UIViewController?)?

    public var topRouter: Router {
        self.nextRouter?.topRouter ?? self
    }

    public var nextRouter: Router? {
        if let router = self.activeItem?.router, self.activeItem?.isValid == true, self.routerIsValid(router) {
            return router
        }
        return nil
    }

    var _activeItem: Routing.Item?

    var activeItem: Routing.Item? {
        if let item = self._activeItem, !item.isValid {
            self._activeItem = nil
        }
        return self._activeItem
    }

    private let subRouters = NSHashTable<AnyObject>.weakObjects()

    var navigationController: UINavigationController? {
        self.navigationControllerProvider?() ?? self.rootViewController?.navigationController
    }

    public var presentingViewController: UIViewController? {
        (self.presentingViewControllerProvider?() ?? self.navigationController) ?? self.rootViewController
    }

    public init() {}

    private weak var rootViewController: UIViewController?

    public func show(_ coordinator: BaseCoordinator, style: PresentationStyle, animated: Bool, completion: VoidClosure?) {
        switch style {
        case .push:
            guard let navVC = self.navigationController else { completion?(); assertionFailure(); return }
            self.dismissActiveItem(animated: true, completion: { [weak self] in
                guard let self = self else { return }
                self._activeItem = Routing.Item(itemType: .coordinator(coordinator), presentationStyle: style)
                let start = coordinator.start(finishHandler: { [weak self] completion in
                    guard let self = self else { return }
                    self.dismissActiveItem(animated: true, completion: completion)
                })
                navVC.pushViewController(start, animated: animated)
                completion?()
            })

        case .present://shouldMakeNavigationController, withCloseButton):
            assertionFailure("unsupported yet")
        }

    }

    public func show(_ context: RouterTransitionContext) {
        switch context.style {
        case .push:
            guard let navVC = self.navigationController else { context.completion?(); assertionFailure(); return }

            self.dismissActiveItem(animated: true) { [weak self] in
                guard let self = self else { return }
                self._activeItem = Routing.Item(itemType: .router(holder: RouterHolder(context.container.router)), presentationStyle: context.style)
                navVC.pushViewController(context.container.viewControllerToShow, animated: context.animated)

                context.completion?()
            }

        case let .present(navControllerConfig, withCloseButton):
            guard let presentVC = self.presentingViewController else { context.completion?(); assertionFailure(); return }
            self.dismissActiveItem(animated: true) {
                self._activeItem = Routing.Item(itemType: .router(holder: RouterHolder(context.container.router)), presentationStyle: context.style)
                let vc: UIViewController
                if navControllerConfig != nil || withCloseButton {
                    vc = UINavigationController(rootViewController: context.container.viewControllerToShow)
                    if navControllerConfig?.fullScreen == true { vc.modalPresentationStyle = .fullScreen }
                }
                else {
                    vc = context.container.viewControllerToShow
                }
                if withCloseButton {
                    let image = UIImage(systemName: "xmark")! // Asset.close.image.withRenderingMode(.alwaysTemplate)
                    context.container.viewControllerToShow.navigationItem.leftBarButtonItem = BlockBarButtonItem.item(with: image, handler: { [weak self] in
                        self?.presentingViewController?.dismiss(animated: true)
                    })
                }
                presentVC.present(vc, animated: context.animated)
                context.completion?()
            }
        }
    }

    public func dismissActiveItem(animated: Bool, completion: VoidClosure?) {
        guard let activeItem = self.activeItem, activeItem.isValid else {
            completion?()
            return
        }

        switch activeItem.presentationStyle {
        case .push:
            self._activeItem = nil
            if let rootViewController = self.rootViewController, self.navigationController?.viewControllers.contains(rootViewController) == true {
                self.navigationController?.popToViewController(rootViewController, animated: animated, completion: completion)
            }
            else {
                self.navigationController?.popViewController(animated: animated, completion: completion)
            }
        case .present:
            self._activeItem = nil
            if (self.presentingViewController?.presentedViewController) != nil {
                self.presentingViewController?.dismiss(animated: animated, completion: completion)
            }
            else {
                completion?()
            }
        }
    }

    public func set(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        (self.subRouters.allObjects as? [Router] ?? []).forEach { router in
            router.set(rootViewController: rootViewController)
        }
    }

//    public func makeBusy() -> BusyIndicator? {
//        self.presentingViewController?.makeBusy() ?? self.navigationController?.makeBusy()
//    }

    public func addSubRouter(_ router: Router) {
        self.subRouters.add(router)
        self.rootViewController.map(router.set(rootViewController: ))
    }

    private func routerIsValid(_ router: Router) -> Bool {
        if let router = router as? BaseRouter {
            return router.navigationController != nil || router.presentingViewController != nil
        }
        return true
    }

}

//extension BaseRouter: AlertRouter {
//    public func show(_ alert: Alert) {
//        let alertController = alert.asAlertViewController
//        self.presentingViewController?.present(alertController, animated: true)
//    }
//}

open class BaseCoordinator {

    public private(set) weak var rootRouter: Router? = nil
    private var finishHandler: ((_ didDismissHandler: @escaping VoidClosure) -> Void)? = nil

    public init() {
    }

    open func makeInitialModule() -> (viewController: UIViewController, router: Router) {
        fatalError()
    }

    public func start(finishHandler: @escaping (_ didDismissHandler: @escaping VoidClosure) -> Void) -> UIViewController {
        self.finishHandler = finishHandler
        let module = self.makeInitialModule()
        self.rootRouter = module.router

        return module.viewController
    }

    public func onFinish(_ completion: VoidClosure?) {
        if let handler = self.finishHandler {
            handler({
                completion?()
            })
        }
        else {
            completion?()
        }
    }
}


extension UINavigationController {
    func pushViewController(viewController: UIViewController, animated: Bool, completion: VoidClosure?) {
        pushViewController(viewController, animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }

    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: VoidClosure?) {
        self.popToViewController(viewController, animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }

    func popToRootViewController(animated: Bool, completion: VoidClosure?) {
        self.popToRootViewController(animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }

    func popViewController(animated: Bool, completion: VoidClosure?) {
        popViewController(animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }
}

public protocol ModuleContainerProvider {
    func request(completion: @escaping (Result<ModuleContainer, Error>) -> Void)
}

open class ModuleContainer {
    public let viewControllerToShow: UIViewController
    public let router: Router

    public init(viewControllerToShow: UIViewController, router: Router) {
        self.viewControllerToShow = viewControllerToShow
        self.router = router
        router.set(rootViewController: viewControllerToShow)
    }
}


public enum PresentationStyle {
    case push
    case present(navigationControllerConfig: NavigationControllerConfig? = nil, withCloseButton: Bool = false)
}

public struct NavigationControllerConfig {
    public static let `default` = NavigationControllerConfig(fullScreen: false)
    let fullScreen: Bool

    public init(fullScreen: Bool) {
        self.fullScreen = fullScreen
    }
}

public struct RouterTransitionContext {
    let container: ModuleContainer
    let style: PresentationStyle
    let animated: Bool
    let completion: VoidClosure?

    public init(container: ModuleContainer, style: PresentationStyle, animated: Bool, completion: VoidClosure?) {
        self.container = container
        self.style = style
        self.animated = animated
        self.completion = completion
    }
}

//public protocol LinkRouter {
//    func open(urlString: String?)
//    func open(url: URL)
//}
//
//public extension LinkRouter where Self: BaseRouter {
//    func open(urlString: String?) {
//        guard let urlString = urlString, !urlString.isEmpty, let url = URL(string: urlString) else { return }
//        self.open(url: url)
//    }

//    func open(url: URL) {
//        let context = WebViewContext(moduleOutput: nil, url: url)
//        let container = WebViewContainer.assemble(with: context)
//        let navigationControllerConfig = NavigationControllerConfig(fullScreen: false)
//        let transition = RouterTransitionContext(container: container, style: .present(navigationControllerConfig: navigationControllerConfig, withCloseButton: true), animated: true, completion: nil)
//        self.show(transition)
//    }
//}

public final class BlockBarButtonItem: UIBarButtonItem {
    private var handler: VoidClosure?

    public static func item(with systemItem: UIBarButtonItem.SystemItem, handler: @escaping VoidClosure) -> BlockBarButtonItem {
        let result = BlockBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        result.selfSetup(handler: handler)
        return result
    }

    public static func item(title: String, handler: @escaping VoidClosure) -> BlockBarButtonItem {
        let result = BlockBarButtonItem(title: title,
                style: .plain,
                target: nil,
                action: nil)
        result.selfSetup(handler: handler)
        return result
    }

    public static func item(with image: UIImage, handler: @escaping VoidClosure) -> BlockBarButtonItem {
        let result = BlockBarButtonItem(image: image,
                style: .plain,
                target: nil,
                action: nil
        )
        result.selfSetup(handler: handler)
        return result
    }

    private func selfSetup(handler: @escaping VoidClosure) {
        self.target = self
        self.action = #selector(onTap)
        self.handler = handler
    }

    @objc private func onTap() {
        self.handler?()
    }
}
