//
//  StringValueMatchRule.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 9/5/18.
//  Copyright © 2019 Al Tayer Group LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
