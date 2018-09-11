//
//  StringRegexRule.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 9/4/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
//

/// String regex rule to match with regular expressions.
public struct StringRegexRule: Rule {

    private let regex: String
    /// Error to be returned if validation fails.
    public var error: Error

    /**
     Initialiser.

     - parameter regex: Regular expression string to be matched against.
     - parameter error: Error to be returned in case of validation failure.
     */
    public init(
        regex: String,
        error: Error = ValidationError.regexMismatch
        ) {

        self.regex = regex
        self.error = error
    }

    /**
     Validation implementation method.

     - parameter value: The value to be passed in for validation.
     - returns: A result object with success or failure with errors.

     - note: Checks if the passed in `value` matches the regular expression in `regex`.
     */
    public func validate(value: Any) -> Result {

        guard let inputValue = value as? String else {

            return Result.fail(value, withErrors: [ValidationError.invalidType])
        }

        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: inputValue)

        return isValid ? Result.succeed(inputValue) : Result.fail(inputValue, withErrors: [error])
    }
}

extension StringRegexRule {

    private enum Constants {

        static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        static let containsNumber = "(\\D*\\d\\D*){%d,%d}"
        static let containsUpperCase = "([^A-Z]*[A-Z][^A-Z]*){%d,%d}"
        static let containsLowerCase = "([^a-z]*[a-z][^a-z]*){%d,%d}"
        static let numbersOnly = "^[0-9]*$"
        static let lowerCaseOnly = "^[a-z]*$"
        static let upperCaseOnly = "^[A-Z]*$"
    }

    /// Factory builder to create rule with email regex.
    public static let email = StringRegexRule(
        regex: Constants.email,
        error: ValidationError.invalidEmail
    )

    /**
     Factory method to create rule which checks for strings with digits in min...max range.

     - parameter min: Minimum number of digits needed. Default is `1`
     - parameter max: Maximum number of digits allowed. Default is `255`
     - parameter error: Error object to be returned in case of validation failure. Default is
     `numberNotFound` error.

     - note: Maximum value allowed for max is 255. `min` must be less than or equal to `max`.
     */
    public static func containsNumber(
        min: UInt8 = 1,
        max: UInt8 = UInt8.max,
        error: Error = ValidationError.numberNotFound
        ) -> StringRegexRule {

        assert(min <= max, "min should be less than or equal to max")

        let regex = String(format: Constants.containsNumber, min, max)
        return StringRegexRule(regex: regex, error: error)
    }

    /**
     Factory method to create rule which checks for strings with uppercase chars in min...max range.

     - parameter min: Minimum number of uppercase chars needed. Default is `1`
     - parameter max: Maximum number of uppercase chars allowed. Default is `255`
     - parameter error: Error object to be returned in case of validation failure. Default is
     `upperCaseNotFound` error.

     - note: Maximum value allowed for max is 255. `min` must be less than or equal to `max`.
     */
    public static func containsUpperCase(
        min: UInt8 = 1,
        max: UInt8 = UInt8.max,
        error: Error = ValidationError.upperCaseNotFound
        ) -> StringRegexRule {

        assert(min <= max, "min should be less than or equal to max")

        let regex = String(format: Constants.containsUpperCase, min, max)
        return StringRegexRule(regex: regex, error: error)
    }

    /**
     Factory method to create rule which checks for strings with lowercase chars in min...max range.

     - parameter min: Minimum number of lowercase chars needed. Default is `1`
     - parameter max: Maximum number of lowercase chars allowed. Default is `255`
     - parameter error: Error object to be returned in case of validation failure. Default is
     `lowerCaseNotFound` error.

     - note: Maximum value allowed for max is 255. `min` must be less than or equal to `max`.
     */
    public static func containsLowerCase(
        min: UInt8 = 1,
        max: UInt8 = UInt8.max,
        error: Error = ValidationError.lowerCaseNotFound
        ) -> StringRegexRule {

        assert(min <= max, "min should be less than or equal to max")

        let regex = String(format: Constants.containsLowerCase, min, max)
        return StringRegexRule(regex: regex, error: error)
    }

    /// Factory instance to create rule which checks for strings with numbers only.
    public static let numbersOnly = StringRegexRule(
        regex: Constants.numbersOnly,
        error: ValidationError.invalidType
    )

    /// Factory instance to create rule which checks for strings with lower case chars only.
    public static let lowerCaseOnly = StringRegexRule(
        regex: Constants.lowerCaseOnly,
        error: ValidationError.invalidType
    )

    /// Factory instance to create rule which checks for strings with upper case chars only.
    public static let upperCaseOnly = StringRegexRule(
        regex: Constants.upperCaseOnly,
        error: ValidationError.invalidType
    )
}
