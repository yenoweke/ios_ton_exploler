// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {

  public enum Common {
    /// Apply
    public static let apply = L10n.tr("Localizable", "Common.Apply")
    /// Error
    public static let error = L10n.tr("Localizable", "Common.Error")
    /// Reset
    public static let reset = L10n.tr("Localizable", "Common.Reset")
  }

  public enum InputAddress {
    /// Go
    public static let go = L10n.tr("Localizable", "InputAddress.Go")
    /// Enter TON Address
    public static let input = L10n.tr("Localizable", "InputAddress.Input")
    public enum Error {
      /// Address is not valid
      public static let isNotValid = L10n.tr("Localizable", "InputAddress.Error.isNotValid")
    }
  }

  public enum Message {
    /// Body hash
    public static let bodyHash = L10n.tr("Localizable", "Message.bodyHash")
    /// Creation LT
    public static let creationLT = L10n.tr("Localizable", "Message.creationLT")
    /// Destination
    public static let destination = L10n.tr("Localizable", "Message.destination")
    /// Empty
    public static let empty = L10n.tr("Localizable", "Message.empty")
    /// Forward fee
    public static let forwardFee = L10n.tr("Localizable", "Message.forwardFee")
    /// IHR fee
    public static let ihrFee = L10n.tr("Localizable", "Message.ihrFee")
    /// In:
    public static let `in` = L10n.tr("Localizable", "Message.in")
    /// Message
    public static let message = L10n.tr("Localizable", "Message.message")
    /// Out:
    public static let out = L10n.tr("Localizable", "Message.out")
    /// Source
    public static let source = L10n.tr("Localizable", "Message.source")
    /// Value
    public static let value = L10n.tr("Localizable", "Message.value")
  }

  public enum Transaction {
    public enum Details {
      /// Logical time:
      public static let logicalTime = L10n.tr("Localizable", "Transaction.Details.logicalTime")
      /// Messages:
      public static let messages = L10n.tr("Localizable", "Transaction.Details.messages")
      /// %@ input, %@ output
      public static func messagesInfo(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "Transaction.Details.messagesInfo", String(describing: p1), String(describing: p2))
      }
      /// Other fee:
      public static let otherFee = L10n.tr("Localizable", "Transaction.Details.otherFee")
      /// Storage fee:
      public static let storageFee = L10n.tr("Localizable", "Transaction.Details.storageFee")
      /// TimeStamp
      public static let timeStamp = L10n.tr("Localizable", "Transaction.Details.timeStamp")
      /// Transaction Information
      public static let title = L10n.tr("Localizable", "Transaction.Details.title")
      /// Total fee:
      public static let totalFee = L10n.tr("Localizable", "Transaction.Details.totalFee")
    }
    public enum Filter {
      /// All
      public static let all = L10n.tr("Localizable", "Transaction.Filter.all")
      /// Max value
      public static let maxValue = L10n.tr("Localizable", "Transaction.Filter.maxValue")
      /// Message types
      public static let messageTypes = L10n.tr("Localizable", "Transaction.Filter.messageTypes")
      /// Min value
      public static let minValue = L10n.tr("Localizable", "Transaction.Filter.minValue")
      /// Only IN
      public static let onlyIn = L10n.tr("Localizable", "Transaction.Filter.onlyIn")
      /// Only OUT
      public static let onlyOut = L10n.tr("Localizable", "Transaction.Filter.onlyOut")
      /// Filter transactions
      public static let title = L10n.tr("Localizable", "Transaction.Filter.title")
    }
    public enum List {
      /// Balance:
      public static let addressBalance = L10n.tr("Localizable", "Transaction.List.addressBalance")
      /// Transactions
      public static let title = L10n.tr("Localizable", "Transaction.List.title")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
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
