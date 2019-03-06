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
