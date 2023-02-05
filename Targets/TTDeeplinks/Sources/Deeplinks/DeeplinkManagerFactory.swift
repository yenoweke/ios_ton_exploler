public enum DeeplinkManagerFactory {
    public static func make() -> DeeplinkManager {
        DeeplinkManagerImpl(parser: DeeplinkParserImpl())
    }
}
