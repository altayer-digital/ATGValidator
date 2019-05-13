//
//  RangeRule.swift
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
