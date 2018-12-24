//
//  Rule.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 8/29/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
//

/**
 Base protocol to be conformed while creating a new validation rule.

 - note:
 There are 2 requirements in this protocol
 - error: This is the error, which will be returned if the rule is failed on the input.
 - validate(value:): This method should do the actual validation and return a result with status
 as either success or failure. In case of failure, the result's errors property needs to be filled
 with the corresponding error object.
 */
public protocol Rule {

    /// Error object associated with the specific rule.
    var error: Error { get set }

    /**
     Validation implementation method.
     - parameter value: The value to be passed in for validation.
     - returns: A result object with success or failure with errors.
     */
    func validate(value: Any) -> Result
}

public extension Rule {

    /**
     Chaining method to set custom error object.
     - parameter error: The value to be set.
     - returns: Returns new object with given error.
     */
    public func with(error: Error) -> Rule {

        var rule = self
        rule.error = error
        return rule
    }

    /**
     Chaining method to set errorMessage to error object using CustomValidationError.
     - parameter errorMessage: The value to be set.
     - returns: Returns new object with a new error object which has given error message.
     */
    public func with(errorMessage: String) -> Rule {

        var rule = self
        rule.error = CustomValidationError(errorMessage)
        return rule
    }
}
