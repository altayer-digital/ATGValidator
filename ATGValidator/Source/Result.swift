//
//  Result.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 8/30/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
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
