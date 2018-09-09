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

// TODO: Add documentation

public struct StringRegexRule: Rule {

    private let regex: String
    public var error: Error

    public init(
        regex: String,
        error: Error = ValidationError.regexMismatch
        ) {

        self.regex = regex
        self.error = error
    }

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

    public static let email = StringRegexRule(
        regex: Constants.email,
        error: ValidationError.invalidEmail
    )

    public static func containsNumber(min: UInt8 = 1, max: UInt8 = UInt8.max) -> StringRegexRule {

        assert(min <= max, "min should be less than or equal to max")

        let regex = String(format: Constants.containsNumber, min, max)
        return StringRegexRule(regex: regex, error: ValidationError.numberNotFound)
    }

    public static func containsUpperCase(min: UInt8 = 1, max: UInt8 = UInt8.max) -> StringRegexRule {

        assert(min <= max, "min should be less than or equal to max")

        let regex = String(format: Constants.containsUpperCase, min, max)
        return StringRegexRule(regex: regex, error: ValidationError.upperCaseNotFound)
    }

    public static func containsLowerCase(min: UInt8 = 1, max: UInt8 = UInt8.max) -> StringRegexRule {

        assert(min <= max, "min should be less than or equal to max")

        let regex = String(format: Constants.containsLowerCase, min, max)
        return StringRegexRule(regex: regex, error: ValidationError.lowerCaseNotFound)
    }

    public static let numbersOnly = StringRegexRule(
        regex: Constants.numbersOnly,
        error: ValidationError.invalidType
    )

    public static let lowerCaseOnly = StringRegexRule(
        regex: Constants.lowerCaseOnly,
        error: ValidationError.invalidType
    )

    public static let upperCaseOnly = StringRegexRule(
        regex: Constants.upperCaseOnly,
        error: ValidationError.invalidType
    )
}
