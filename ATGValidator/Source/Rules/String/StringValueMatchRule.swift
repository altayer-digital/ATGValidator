//
//  StringValueMatchRule.swift
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

// TODO: Add docuementation

public struct StringValueMatchRule: Rule {

    let base: ValidatableInterface
    public var error: Error

    public init(base: ValidatableInterface, error: Error = ValidationError.notEqual) {

        self.base = base
        self.error = error
    }

    public func validate(value: Any) -> Result {

        guard let baseValue = base.inputValue as? String,
            let valueToTest = value as? String else {
            return Result.fail(value, withErrors: [ValidationError.invalidType])
        }

        let isValid = (baseValue == valueToTest)
        return isValid ? .succeed(value) : .fail(value, withErrors: [error])
    }
}
