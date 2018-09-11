//
//  LengthRule.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 8/30/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
//

/// String length check rule.
public struct StringLengthRule: Rule {

    private let min: Int
    private let max: Int
    private let trimWhiteSpace: Bool
    private let ignoreCharacterSet: CharacterSet?

    /// Error to be returned if validation fails.
    public var error: Error

    /**
     Initialiser.

     - parameter min: Lower string length limit.
     - parameter max: Upper string length limit.
     - parameter trimWhiteSpace: Whether to trim whitespace and newline from input string before
     validation.
     - parameter ignoreCharactersIn: Characterset of which all characters will be ignored from the
     input string before validation.
     - parameter error: Error to be returned in case of validation failure.
     */
    public init(
        min: Int = 0,
        max: Int = Int.max,
        trimWhiteSpace: Bool = true,
        ignoreCharactersIn characterSet: CharacterSet? = nil,
        error: Error = ValidationError.lengthOutOfRange
        ) {

        self.min = min
        self.max = max
        self.trimWhiteSpace = trimWhiteSpace
        self.ignoreCharacterSet = characterSet
        self.error = error
    }

    /**
     Factory method to create a rule with only minimum length requirement.

     - parameter min: Lower string length limit.
     - parameter error: Error to be returned in case of validation failure.
     */
    public static func min(
        _ min: Int,
        error: Error = ValidationError.shorterThanMinimumLength
        ) -> StringLengthRule {

        return StringLengthRule(min: min, error: error)
    }

    /**
     Factory method to create a rule with only maximum length requirement.

     - parameter min: Upper string length limit.
     - parameter error: Error to be returned in case of validation failure.
     */
    public static func max(
        _ max: Int,
        error: Error = ValidationError.longerThanMaximumLength
        ) -> StringLengthRule {

        return StringLengthRule(max: max, error: error)
    }

    /**
     Validation implementation method.

     - parameter value: The value to be passed in for validation.
     - returns: A result object with success or failure with errors.

     - note: Checks if the passed in `value`'s length is between `min` and `max` both including.
     */
    public func validate(value: Any) -> Result {

        guard let inputValue = value as? String else {

            return Result.fail(value, withErrors: [ValidationError.invalidType])
        }

        var valueToBeValidated = inputValue

        if let characterSet = ignoreCharacterSet {
            let passed = valueToBeValidated.unicodeScalars.filter { !characterSet.contains($0) }
            valueToBeValidated = String(String.UnicodeScalarView(passed))
        }
        if trimWhiteSpace {
            valueToBeValidated = valueToBeValidated.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }

        let isValid = valueToBeValidated.count >= min && valueToBeValidated.count <= max

        return isValid ? Result.succeed(inputValue) : Result.fail(inputValue, withErrors: [error])
    }
}
