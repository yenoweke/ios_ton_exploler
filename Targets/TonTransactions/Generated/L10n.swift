// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum Account {
    public enum Action {
      /// Add to watchlist
      public static let addToWatchList = L10n.tr("Localizable", "Account.Action.addToWatchList", fallback: "Add to watchlist")
      /// Delete from watchlist
      public static let deleteFromWatchList = L10n.tr("Localizable", "Account.Action.deleteFromWatchList", fallback: "Delete from watchlist")
      /// Subsribe
      public static let subsribeOnUpdates = L10n.tr("Localizable", "Account.Action.subsribeOnUpdates", fallback: "Subsribe")
      /// Unsubsribe
      public static let unsubsribeOnUpdates = L10n.tr("Localizable", "Account.Action.unsubsribeOnUpdates", fallback: "Unsubsribe")
    }
    public enum PushPermission {
      public enum ToSettings {
        /// Settings
        public static let button = L10n.tr("Localizable", "Account.PushPermission.ToSettings.button", fallback: "Settings")
        /// You can enable push notifications in settings, to receive updates.
        public static let message = L10n.tr("Localizable", "Account.PushPermission.ToSettings.message", fallback: "You can enable push notifications in settings, to receive updates.")
        /// Push Notifications
        public static let title = L10n.tr("Localizable", "Account.PushPermission.ToSettings.title", fallback: "Push Notifications")
      }
    }
  }
  public enum Common {
    /// Apply
    public static let apply = L10n.tr("Localizable", "Common.Apply", fallback: "Apply")
    /// Copy
    public static let copy = L10n.tr("Localizable", "Common.Copy", fallback: "Copy")
    /// Error
    public static let error = L10n.tr("Localizable", "Common.Error", fallback: "Error")
    /// Remove
    public static let remove = L10n.tr("Localizable", "Common.Remove", fallback: "Remove")
    /// Reset
    public static let reset = L10n.tr("Localizable", "Common.Reset", fallback: "Reset")
    /// Retry
    public static let retry = L10n.tr("Localizable", "Common.Retry", fallback: "Retry")
    /// Save
    public static let save = L10n.tr("Localizable", "Common.Save", fallback: "Save")
  }
  public enum Edit {
    /// Full Address
    public static let fullAddress = L10n.tr("Localizable", "Edit.fullAddress", fallback: "Full Address")
    /// Enter short name
    public static let placeholder = L10n.tr("Localizable", "Edit.placeholder", fallback: "Enter short name")
    /// Set short name
    public static let title = L10n.tr("Localizable", "Edit.title", fallback: "Set short name")
  }
  public enum InputAddress {
    /// Go
    public static let go = L10n.tr("Localizable", "InputAddress.Go", fallback: "Go")
    /// Enter TON Address
    public static let input = L10n.tr("Localizable", "InputAddress.Input", fallback: "Enter TON Address")
    public enum Error {
      /// Address is not valid
      public static let isNotValid = L10n.tr("Localizable", "InputAddress.Error.isNotValid", fallback: "Address is not valid")
    }
  }
  public enum Message {
    /// Body hash
    public static let bodyHash = L10n.tr("Localizable", "Message.bodyHash", fallback: "Body hash")
    /// Creation LT
    public static let creationLT = L10n.tr("Localizable", "Message.creationLT", fallback: "Creation LT")
    /// Destination
    public static let destination = L10n.tr("Localizable", "Message.destination", fallback: "Destination")
    /// Empty
    public static let empty = L10n.tr("Localizable", "Message.empty", fallback: "Empty")
    /// Forward fee
    public static let forwardFee = L10n.tr("Localizable", "Message.forwardFee", fallback: "Forward fee")
    /// IHR fee
    public static let ihrFee = L10n.tr("Localizable", "Message.ihrFee", fallback: "IHR fee")
    /// In:
    public static let `in` = L10n.tr("Localizable", "Message.in", fallback: "In:")
    /// Message
    public static let message = L10n.tr("Localizable", "Message.message", fallback: "Message")
    /// Out:
    public static let out = L10n.tr("Localizable", "Message.out", fallback: "Out:")
    /// Source
    public static let source = L10n.tr("Localizable", "Message.source", fallback: "Source")
    /// Value
    public static let value = L10n.tr("Localizable", "Message.value", fallback: "Value")
  }
  public enum Tab {
    public enum Search {
      /// Search
      public static let title = L10n.tr("Localizable", "Tab.Search.title", fallback: "Search")
    }
    public enum Watchlist {
      /// Watchlist
      public static let title = L10n.tr("Localizable", "Tab.Watchlist.title", fallback: "Watchlist")
    }
  }
  public enum Transaction {
    public enum Details {
      /// Logical time:
      public static let logicalTime = L10n.tr("Localizable", "Transaction.Details.logicalTime", fallback: "Logical time:")
      /// Messages:
      public static let messages = L10n.tr("Localizable", "Transaction.Details.messages", fallback: "Messages:")
      /// %@ input, %@ output
      public static func messagesInfo(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "Transaction.Details.messagesInfo", String(describing: p1), String(describing: p2), fallback: "%@ input, %@ output")
      }
      /// Other fee:
      public static let otherFee = L10n.tr("Localizable", "Transaction.Details.otherFee", fallback: "Other fee:")
      /// Storage fee:
      public static let storageFee = L10n.tr("Localizable", "Transaction.Details.storageFee", fallback: "Storage fee:")
      /// TimeStamp
      public static let timeStamp = L10n.tr("Localizable", "Transaction.Details.timeStamp", fallback: "TimeStamp")
      /// Transaction Information
      public static let title = L10n.tr("Localizable", "Transaction.Details.title", fallback: "Transaction Information")
      /// Total fee:
      public static let totalFee = L10n.tr("Localizable", "Transaction.Details.totalFee", fallback: "Total fee:")
    }
    public enum Filter {
      /// All
      public static let all = L10n.tr("Localizable", "Transaction.Filter.all", fallback: "All")
      /// Max value
      public static let maxValue = L10n.tr("Localizable", "Transaction.Filter.maxValue", fallback: "Max value")
      /// Message types
      public static let messageTypes = L10n.tr("Localizable", "Transaction.Filter.messageTypes", fallback: "Message types")
      /// Min value
      public static let minValue = L10n.tr("Localizable", "Transaction.Filter.minValue", fallback: "Min value")
      /// Only IN
      public static let onlyIn = L10n.tr("Localizable", "Transaction.Filter.onlyIn", fallback: "Only IN")
      /// Only OUT
      public static let onlyOut = L10n.tr("Localizable", "Transaction.Filter.onlyOut", fallback: "Only OUT")
      /// Filter transactions
      public static let title = L10n.tr("Localizable", "Transaction.Filter.title", fallback: "Filter transactions")
    }
    public enum List {
      /// Balance:
      public static let addressBalance = L10n.tr("Localizable", "Transaction.List.addressBalance", fallback: "Balance:")
      /// Transactions
      public static let title = L10n.tr("Localizable", "Transaction.List.title", fallback: "Transactions")
    }
  }
  public enum Watchlist {
    /// Copy full address
    public static let copyFullAddress = L10n.tr("Localizable", "Watchlist.copyFullAddress", fallback: "Copy full address")
    /// Edit
    public static let editShortName = L10n.tr("Localizable", "Watchlist.editShortName", fallback: "Edit")
    /// Watchlist
    public static let title = L10n.tr("Localizable", "Watchlist.title", fallback: "Watchlist")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
