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

/// Rule to match the value to another UI elements's value. Eg usage is confirm password case.
public struct StringValueMatchRule: Rule {

    let base: ValidatableInterface
    /// Error to be returned if validation fails.
    public var error: Error

    /**
     Initialiser.

     - parameter base: The UI element whose value must be comapred against.
     - parameter error: Error to be returned in case of validation failure. Default is `notEqual`
     */
    public init(base: ValidatableInterface, error: Error = ValidationError.notEqual) {

        self.base = base
        self.error = error
    }

    /**
     Validation implementation method.
     - parameter value: The value to be passed in for validation.
     - returns: A result object with success or failure with errors.

     - note: Checks if the passed in `value` is equal to the `base` element's value.
     */
    public func validate(value: Any) -> Result {

        guard let baseValue = base.inputValue as? String,
            let valueToTest = value as? String else {
            return Result.fail(value, withErrors: [ValidationError.invalidType])
        }

        let isValid = (baseValue == valueToTest)
        return isValid ? .succeed(value) : .fail(value, withErrors: [error])
    }
}
