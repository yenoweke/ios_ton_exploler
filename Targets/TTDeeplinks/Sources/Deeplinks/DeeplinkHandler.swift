public protocol DeeplinkHandler: AnyObject {
    func handle(_ deeplink: Deeplink) -> Bool
}
