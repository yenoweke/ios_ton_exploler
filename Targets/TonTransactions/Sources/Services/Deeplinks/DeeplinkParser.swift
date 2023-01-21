import Foundation

protocol DeeplinkParser {
    func parse(_ url: URL) -> Deeplink?
    func parse(_ urlString: String) -> Deeplink?
}

final class DeeplinkParserImpl: DeeplinkParser {
    func parse(_ url: URL) -> Deeplink? {
        let currentScheme = "tonsnow"
        let supportedHost = "current"

        guard
            url.scheme == currentScheme,
            url.host == supportedHost
        else {
            return nil
        }
        
        var components = url.pathComponents.filter({ $0 != "/"})
        if let path = extract(&components) {
            return Deeplink(host: currentScheme, path: path)
        }
        else {
            return Deeplink(host: currentScheme, path: .unkonwn)
        }
    }

    func parse(_ urlString: String) -> Deeplink? {
        guard let url = URL(string: urlString) else { return nil }
        return parse(url)
    }
    
    private func extract(_ components: inout [String]) -> Deeplink.Path? {
        guard components.count == 2 else { return nil }
        
        if components[0] == "account" {
            return .account(components[1])
        }
        
        return nil
    }
    
}
