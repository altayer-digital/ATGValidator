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

// TODO: Add documentation

public struct StringLengthRule: Rule {

    private let min: Int
    private let max: Int
    private let trimWhiteSpace: Bool
    public var error: Error

    public init(
        min: Int = 0,
        max: Int = Int.max,
        trimWhiteSpace: Bool = true,
        error: Error = ValidationError.lengthOutOfRange
        ) {

        self.min = min
        self.max = max
        self.trimWhiteSpace = trimWhiteSpace
        self.error = error
    }

    public static func min(
        _ min: Int,
        error: Error = ValidationError.shorterThanMinimumLength
        ) -> StringLengthRule {

        return StringLengthRule(min: min, error: error)
    }

    public static func max(
        _ max: Int,
        error: Error = ValidationError.longerThanMaximumLength
        ) -> StringLengthRule {

        return StringLengthRule(max: max, error: error)
    }

    public func validate(value: Any) -> Result {

        guard let inputValue = value as? String else {

            return Result.fail(value, withErrors: [ValidationError.invalidType])
        }

        var valueToBeValidated = inputValue

        if trimWhiteSpace {
            valueToBeValidated = valueToBeValidated.trimmingCharacters(in: CharacterSet.whitespaces)
        }

        let isValid = valueToBeValidated.count >= min && valueToBeValidated.count <= max

        return isValid ? Result.succeed(inputValue) : Result.fail(inputValue, withErrors: [error])
    }
}
