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

/// Range rule. Values that define limit must conform to `Comparable` protocol.
public struct RangeRule<T: Comparable>: Rule {

    private let min: T
    private let max: T
    /// Error to be returned if validation fails.
    public var error: Error

    /**
     Initialiser.

     - parameter min: Lower range limit.
     - parameter max: Upper range limit.
     - parameter error: Error to be returned in case of validation failure.
     */
    public init(min: T, max: T, error: Error = ValidationError.valueOutOfRange) {

        self.min = min
        self.max = max
        self.error = error
    }

    /**
     Validation implementation method.

     - parameter value: The value to be passed in for validation.
     - returns: A result object with success or failure with errors.

     - note: Checks if the passed in `value` is between `min` and `max` both values including.
     */
    public func validate(value: Any) -> Result {

        guard let valueToTest = value as? T else {
            return Result.fail(value, withErrors: [ValidationError.invalidType])
        }

        let isValid = (valueToTest >= min && valueToTest <= max)
        return isValid ? .succeed(valueToTest) : .fail(valueToTest, withErrors: [error])
    }
}
