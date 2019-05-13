//
//  EqualityRule.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 9/4/18.
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

/// Equality rule. Value to be checked for this rule must be conforming to `Equatable`.
public struct EqualityRule<T: Equatable>: Rule {

    /// Mode of rule execution.
    public enum Mode {

        case equal
        case notEqual
    }

    let test: T
    private let mode: Mode
    /// Error to be returned if validation fails.
    public var error: Error
    /**
     Initialiser.

     - parameter value: The value to be compared against.
     - parameter error: Error to be returned in case of validation failure.
     */
    public init(value: T, mode: Mode = .equal, error: Error? = nil) {

        self.test = value
        self.mode = mode
        if let error = error {
            self.error = error
        } else {
            self.error = mode == .equal ? ValidationError.notEqual : ValidationError.equal
        }
    }

    /**
     Validation implementation method.

     - parameter value: The value to be passed in for validation.
     - returns: A result object with success or failure with errors.

     - note: Checks if the passed in `value` is equal to the `test` value.
     */
    public func validate(value: Any) -> Result {

        guard let valueToTest = value as? T else {
            return Result.fail(value, withErrors: [ValidationError.invalidType])
        }

        if mode == .equal {
            return valueToTest == test ? .succeed(valueToTest) : .fail(valueToTest, withErrors: [error])
        } else {
            return valueToTest != test ? .succeed(valueToTest) : .fail(valueToTest, withErrors: [error])
        }
    }
}
