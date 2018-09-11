//
//  PaymentCardType.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 9/5/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
//

/// Payment card type enum for credit/debit cards
public enum PaymentCardType: String {

    internal enum Constants {

        /// Minimum length of card number required before doing number validation.
        static let minimumLengthForValidation = 12
        /// Minimum length of card number required before performing suggestion.
        static let minimumLengthForSuggestion = 4
    }

    case amex = "American Express"
    case mastercard = "MasterCard"
    case maestro = "Maestro"
    case visa = "Visa"
    case visaElectron = "Visa Electron"
    case discover = "Discover"
    case dinersClub = "Diners Club"

    /// Helper to return all supported card types.
    public static var all: [PaymentCardType] = [
        .amex,
        .mastercard,
        .maestro,
        .visaElectron,
        .visa,
        .discover,
        .dinersClub
    ]

    /**
     Initializer.

     - parameter cardNumber: Credit/Debit card number with which card type should be attempted to
     be made.
     */
    public init?(cardNumber: String) {

        guard let type = PaymentCardType.typeForCardNumber(cardNumber) else {
            return nil
        }

        self.init(rawValue: type.rawValue)
    }

    /**
     Method to get suggested type for a card number.

     - parameter cardNumber: The card number for which suggestion has to be made.
     - returns: The suggestion for card type if any, else nil.

     - note: All card numbers need minimum 4 digits for a suggestion, and for some specific card
     numbers (Eg: MasterCard that starts with 677189 or Visa Electron that starts with 417500),
     minimum 6 digits are needed for a correct suggestion.
     */
    public static func suggestedTypeForCardNumber(_ cardNumber: String?) -> PaymentCardType? {

        guard let cn = cardNumber,
            cn.count >= Constants.minimumLengthForSuggestion else {
                return nil
        }
        return PaymentCardType.all.first {
            return NSPredicate(format: "SELF MATCHES %@", $0.regularExpressionForSuggestion).evaluate(with: cn)
        }
    }

    /// This method actually validates the card number.
    private static func typeForCardNumber(_ cardNumber: String?) -> PaymentCardType? {

        guard let cn = cardNumber else {
            return nil
        }
        return PaymentCardType.all.first {
            return NSPredicate(format: "SELF MATCHES %@", $0.cardNumberRegex).evaluate(with: cn)
        }
    }

    private var cardNumberRegex: String {

        switch self {
        case .amex:
            // 15 digits starts with 34|37
            return "^3[47]\\d{13}$"
        case .mastercard:
            // 16 digits starts with 51-55|2221-2720
            return "^((5[1-5]\\d{4}|677189)\\d{10})|((222[1-9]|22[3-9]\\d|2[3-6]\\d{2}|27[0-1]\\d|2720)\\d{12})$"
        case .maestro:
            // 16 or 19 digits, starting with 5018|5020|5038|6304|6703|6708|6759|6761-6763
            return "^(5018|5020|5038|6304|670[38]|6759|676[1-3])\\d{12}(?:\\d{3})?$"
        case .visaElectron:
            // 13 or 16 digits. starts with 417500|4026|4405|4508|4844|4913|4917.
            return "^(417500\\d{7}|4(026|405|508|844|91[37])\\d{9})(?:\\d{3})?$"
        case .visa:
            // 13 or 16 digits. starts with 4
            return "^4\\d{12}(?:\\d{3})?$"
        case .discover:
            // 16 or 19 digits. starts with 6011|644-649|65|622
            return "^6(?:011|4[4-9]\\d|5\\d{2}|22\\d)\\d{12}(?:\\d{3})?$"
        case .dinersClub:
            // 14 digits. Starting with 300-305|36|38
            return "^3(?:0[0-5]|[68]\\d)\\d{11}$"
        }
    }

    private var regularExpressionForSuggestion: String {

        switch self {
        case .amex:
            return "^3[47][0-9]*$"
        case .mastercard:
            return "^((5[1-5]|677189)\\d*)|((222[1-9]|22[3-9]\\d|2[3-6]\\d{2}|27[0-1]\\d|2720)\\d*)$"
        case .maestro:
            return "^(5018|5020|5038|6304|670[38]|6759|676[1-3])\\d*$"
        case .visaElectron:
            return "^4(17500|026|405|508|844|91[37])\\d*$"
        case .visa:
            return "^4\\d*$"
        case .discover:
            return "^6(?:011|4[4-9]|5|22)\\d*$"
        case .dinersClub:
            return "^3(?:0[0-5]|[68])\\d*$"
        }
    }
}
