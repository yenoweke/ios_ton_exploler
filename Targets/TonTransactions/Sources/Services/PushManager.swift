import UIKit
import UserNotifications
import TTAPIService

protocol PermissionRequestService {
}

protocol PushManager {
    var status: PushManagerStatus { get }

    func requestPermissions(_ handler: @escaping VoidClosure)

    func add(listener: PushManagerStatusChangeListener)
    func remove(listener: PushManagerStatusChangeListener)
}

protocol PushManagerStatusChangeListener: AnyObject {
    func pushManagerDidChangeStatus(_ pushManager: PushManager)
}

enum PushManagerStatus {
    case unknown
    case denied
    case allowed
}

final class PushManagerImpl: NSObject, PushManager {
    private(set) var status: PushManagerStatus = .unknown {
        didSet {
            if oldValue != self.status {
                self.notifyStatusChange()
            }
        }
    }

    private let networkService: PushSubscriptionNetworkService
    private var token: String?
    private var listeners = NSHashTable<AnyObject>.weakObjects()
    private var stateObserver: NSObjectProtocol?

    var appDelegateHandler = AppDelegateHandler()

    init(networkService: PushSubscriptionNetworkService) {
        self.networkService = networkService
        super.init()
        UNUserNotificationCenter.current().delegate = self

        let name = UIApplication.didBecomeActiveNotification
        self.stateObserver = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { [weak self] _ in
            self?.checkNotificationSettings()
        }
        self.appDelegateHandler.didRegisterForRemoteNotificationsHandler = { [weak self] _, data in
            let token = data.reduce("", { $0 + String(format: "%02X", $1) })
            self?.token = token
            self?.forceSendPushToken()
        }
    }

    private func forceSendPushToken() {
        guard let token = self.token else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })
            return
        }
        Task {
            try await self.networkService.subscribe(deviceID: Device.identifier, with: token)
        }
    }
    
    private func pushPermissionDinied() {
        Task {
            try await self.networkService.pushDisabled(deviceID: Device.identifier)
        }
    }

    private func checkNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .denied, .provisional:
                    self?.status = .denied
                    self?.pushPermissionDinied()
                case .authorized:
                    self?.status = .allowed
                    if UIApplication.shared.isRegisteredForRemoteNotifications {
                        self?.forceSendPushToken()
                    }
                    else {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                case .notDetermined, .ephemeral:
                    self?.status = .unknown
                @unknown default:
                    assertionFailure()
                }
            }
        }
    }

    func requestPermissions(_ handler: @escaping VoidClosure) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.status = granted ? .allowed : .denied
                handler()
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    func add(listener: PushManagerStatusChangeListener) {
        self.listeners.add(listener)
    }

    func remove(listener: PushManagerStatusChangeListener) {
        self.listeners.remove(listener)
    }

    private func notifyStatusChange() {
        (self.listeners.allObjects as? [PushManagerStatusChangeListener])?.forEach({ listener in
            listener.pushManagerDidChangeStatus(self)
        })
    }
}

extension PushManagerImpl: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping VoidClosure) {
        completionHandler()
    }
}

private extension PushManagerImpl {
    func url(from notification: UNNotification) -> URL? {
        if let urlString = notification.request.content.userInfo["url"] as? String, let url = URL(string: urlString) {
            return url
        }
        return nil
    }
}
