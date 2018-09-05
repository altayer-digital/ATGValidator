//
//  PaymentCardNumberRule.swift
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

public struct PaymentCardRule: Rule {

    private let acceptedTypes: [PaymentCardType]
    public var error: Error

    public init(
        acceptedTypes: [PaymentCardType],
        error: Error = ValidationError.paymentCardNotSupported
        ) {

        self.acceptedTypes = acceptedTypes
        self.error = error
    }

    public init(error: Error = ValidationError.paymentCardNotSupported) {

        self.init(acceptedTypes: PaymentCardType.all, error: error)
    }

    public func validate(value: Any) -> Result {

        guard let cardNum = value as? String else {
            return .fail(value, withErrors: [ValidationError.invalidType])
        }

        let numbersOnly = cardNum.replacingOccurrences(
            of: "[^0-9]+",
            with: "",
            options: .regularExpression,
            range: nil
        )
        let formattedCardNumber = numbersOnly.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        )

        let suggestedCardType = PaymentCardType.suggestedTypeForCardNumber(formattedCardNumber)

        guard luhnCheck(cardNumber: formattedCardNumber) else {
            return .fail(
                suggestedCardType ?? formattedCardNumber,
                withErrors: [ValidationError.invalidPaymentCardNumber]
            )
        }
        guard let cardType = PaymentCardType(cardNumber: formattedCardNumber) else {
            return .fail(
                suggestedCardType ?? formattedCardNumber,
                withErrors: [ValidationError.invalidPaymentCardNumber]
            )
        }

        let isSupported = acceptedTypes.contains(cardType)
        return isSupported ? .succeed(cardType) : .fail(
            cardType,
            withErrors: [ValidationError.paymentCardNotSupported]
        )
    }

    private func luhnCheck(cardNumber: String) -> Bool {

        guard cardNumber.count > PaymentCardType.Constants.minimumLengthForValidation else {
            return false
        }
        let originalCheckDigit = Int(String(cardNumber.last!))

        var sum = 0
        let reversedCharacters = cardNumber.dropLast().reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else {
                return false
            }
            if idx % 2 == 0 && 0...8 ~= digit {
                sum += (digit * 2) % 9
            } else {
                sum += digit
            }
        }

        sum *= 9
        let computedCheckDigit = sum % 10

        return computedCheckDigit == originalCheckDigit
    }
}
