//
//  RangeRule.swift
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

// TODO: Add docuementation

public struct RangeRule<T: Comparable>: Rule {

    private let min: T
    private let max: T
    public var error: Error

    public init(min: T, max: T, error: Error = ValidationError.valueOutOfRange) {

        self.min = min
        self.max = max
        self.error = error
    }

    public func validate(value: Any) -> Result {

        guard let valueToTest = value as? T else {
            return Result.fail(value, withErrors: [ValidationError.invalidType])
        }

        let isValid = (valueToTest >= min && valueToTest <= max)
        return isValid ? .succeed(valueToTest) : .fail(valueToTest, withErrors: [error])
    }
}
