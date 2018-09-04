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
        static let containsNumber = ".*\\d.*"
        static let containsUpperCase = "^.*?[A-Z].*?$"
        static let containsLowerCase = "^.*?[a-z].*?$"
    }

    public static let email = StringRegexRule(
        regex: Constants.email,
        error: ValidationError.invalidEmail
    )

    public static let containsNumber = StringRegexRule(
        regex: Constants.containsNumber,
        error: ValidationError.numberNotFound
    )

    public static let containsUpperCase = StringRegexRule(
        regex: Constants.containsUpperCase,
        error: ValidationError.upperCaseNotFound
    )

    public static let containsLowerCase = StringRegexRule(
        regex: Constants.containsLowerCase,
        error: ValidationError.lowerCaseNotFound
    )
}
