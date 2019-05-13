//
//  Result.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 8/30/18.
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

/// Result structure to hold validation status, errors and value.
public struct Result {

    /// Status enumeration for validation result
    public enum Status {

        /// Validation is successful.
        case success
        /// Validation is failed.
        case failure
    }

    /// Status of the validation.
    public var status: Status
    /// List of errors corresponding to failed validation rules.
    public var errors: [Error]?
    /// Last valid value/input value.
    public var value: Any

    /**
     Helper factory builder for failure result.

     - parameter value: Value to be stored in the result object.
     - parameter value: List of errors to be associated with result.

     - returns: A result object
     */
    public static func fail(_ value: Any, withErrors errors: [Error]? = nil) -> Result {

        return Result(status: .failure, errors: errors, value: value)
    }

    /**
     Helper factory builder for success result.

     - parameter value: Value to be stored in the result object.

     - returns: A result object
     */
    public static func succeed(_ value: Any) -> Result {

        return Result(status: .success, errors: nil, value: value)
    }
}

extension Result {

    /**
     Method to combine result of the passed in rule with caller in a `logical AND` manner.

     - parameter rule: Result of the rule which needs to be merged.
     - returns: New merged result object.

     - note: The result is a failure if either the caller or the rule's result is failure.
     */
    internal func and(_ rule: Rule) -> Result {

        var result = self
        let newResult = rule.validate(value: result.value)

        switch result.status {
        case .success:
            return newResult
        case .failure:
            if let errors = newResult.errors {
                result.errors?.append(contentsOf: errors)
            }
            result.value = newResult.value
            return result
        }
    }

    /**
     Method to combine result of the passed in rule with caller in a `logical OR` manner.

     - parameter rule: Result of the rule which needs to be merged.
     - returns: New merged result object.

     - note: The result is success if either the caller or the rule's result is success.
     This function returns once the first success case is met. All the errors accumulated upto that
     point will be available in the errors array.
     */
    internal func or(_ rule: Rule) -> Result {

        var result = self

        switch result.status {
        case .success:
            return result
        case .failure:
            let newResult = rule.validate(value: result.value)
            result.status = newResult.status
            result.value = newResult.value
            if let errors = newResult.errors {
                result.errors?.append(contentsOf: errors)
            }
            return result
        }
    }

    /**
     Method to merge the passed in result to the caller.

     - parameter other: Other result which needs to be merged.
     - returns: New merged result object.

     - note: The operation merges both the results and sends a unified result object with all errors
     in it.
     */
    internal func merge(_ other: Result) -> Result {

        switch (status, other.status) {
        case (.success, .success):
            return Result.succeed(value)
        case (.success, .failure):
            return Result.fail(value, withErrors: other.errors)
        case (.failure, .success):
            return Result.fail(value, withErrors: errors)
        case (.failure, .failure):
            return Result.fail(value, withErrors: (errors ?? []) + (other.errors ?? []))
        }
    }
}
