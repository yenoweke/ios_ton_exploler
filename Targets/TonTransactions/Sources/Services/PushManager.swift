import UIKit
import UserNotifications

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

    private var listeners = NSHashTable<AnyObject>.weakObjects()
    private var stateObserver: NSObjectProtocol?

    var appDelegateHandler = AppDelegateHandler()

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        self.checkNotificationSettings()
        let name = UIApplication.didBecomeActiveNotification
        self.stateObserver = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { [weak self] _ in
            self?.checkNotificationSettings()
        }
        self.appDelegateHandler.didRegisterForRemoteNotificationsHandler = { [weak self] _, data in
            let token = data.reduce("", { $0 + String(format: "%02X", $1) })
            print(token)
        }
    }

    private func forceSendPushToken() {
        print("PushManagerImpl / hi there")
    }

    private func checkNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .denied, .provisional:
                    self?.status = .denied
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
        if let listeners = self.listeners.allObjects as? [PushManagerStatusChangeListener] {
            listeners.forEach({ $0.pushManagerDidChangeStatus(self) })
        }
    }
}

extension PushManagerImpl: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        if let router = self.deepLinkRouter,
//           let url = self.url(from: notification),
//           let deepLink = self.deepLinkProcessor.parse(url: url),
//           router.alreadyIn(link: deepLink) {
//            completionHandler([])
//            return
//        }
        completionHandler([.banner, .list, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping VoidClosure) {
//        if let url = self.url(from: response.notification) {
//            self.deepLinkProcessor.process(url: url)
//            self.didHandlePushHandler?(response.notification.request.content.userInfo, url)
//        }
//        else {
//            self.didHandlePushHandler?(response.notification.request.content.userInfo, nil)
//        }
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
