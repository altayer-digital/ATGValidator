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
public struct LengthRule: StringRule {

    var min: Int = 0
    var max: Int = Int.max
    var shouldTrimBeforeValidation: Bool = true
    public var error: Error

    public init(
        min: Int = 0,
        max: Int = Int.max,
        shouldTrimBeforeValidation: Bool = true,
        error: Error = ValidationError.lengthOutOfRange
        ) {

        self.min = min
        self.max = max
        self.shouldTrimBeforeValidation = shouldTrimBeforeValidation
        self.error = error
    }

    public static func min(
        _ min: Int,
        error: Error = ValidationError.shorterThanMinimumLength
        ) -> LengthRule {

        return LengthRule(min: min, error: error)
    }

    public static func max(
        _ max: Int,
        error: Error = ValidationError.longerThanMaximumLength
        ) -> LengthRule {

        return LengthRule(max: max, error: error)
    }

    public func validate(value: Any) -> Result {

        guard let inputValue = value as? String else {

            return Result.fail(value, withErrors: [ValidationError.invalidType])
        }

        var valueToBeValidated = inputValue

        if shouldTrimBeforeValidation {
            valueToBeValidated = valueToBeValidated.trimmingCharacters(in: CharacterSet.whitespaces)
        }

        let isValid = valueToBeValidated.count >= min && valueToBeValidated.count <= max

        return isValid ? Result.succeed(inputValue) : Result.fail(inputValue, withErrors: [error])
    }
}
