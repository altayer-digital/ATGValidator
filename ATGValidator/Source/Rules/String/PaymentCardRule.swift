//
//  PaymentCardNumberRule.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 9/5/18.
//  Copyright © 2019 Al Tayer Group LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

/// Rule to validate credit/debit cards.
public struct PaymentCardRule: Rule {

    private let acceptedTypes: [PaymentCardType]
    /// Error to be returned if validation fails.
    public var error: Error

    /**
     Initialiser.

     - parameter acceptedTypes: List of card types that are accepted for this rule. Default is all
     cards mentioned in `PaymentCardType` enum.
     - parameter error: Error to be returned in case of validation failure.
     Default is `paymentCardNotSupported`
     */
    public init(
        acceptedTypes: [PaymentCardType] = PaymentCardType.all,
        error: Error = ValidationError.paymentCardNotSupported
        ) {

        self.acceptedTypes = acceptedTypes
        self.error = error
    }

    /**
     Validation implementation method.

     - parameter value: The value to be passed in for validation.
     - returns: A result object with success or failure with errors.

     - note: Checks if the passed in `value` is a valid supported card number.

     This method also tries to estimate the card type if the passed in value has atleast 4 valid
     digits. This estimated card type is passed as the value of result in case `luhnCheck` fails or
     if the card number is not long enough for a valid card type.

     If the validation succeeds, the detected card type will be passed as the value of the result
     object.
     */

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
