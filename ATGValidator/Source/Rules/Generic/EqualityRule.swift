//
//  EqualityRule.swift
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

public struct EqualityRule<T: Equatable>: Rule {

    let test: T
    public var error: Error
    public init(value: T, error: Error = ValidationError.notEqual) {

        self.test = value
        self.error = error
    }

    public func canValidate(value: Any) -> Bool {

        return value is T
    }

    public func validate(value: Any) -> Result {

        guard let valueToTest = value as? T else {
            return Result.fail(value, withErrors: [ValidationError.invalidType])
        }

        return valueToTest == test ? .succeed(valueToTest) : .fail(valueToTest, withErrors: [error])
    }
}
