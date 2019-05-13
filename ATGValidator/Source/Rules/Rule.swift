//
//  Rule.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 8/29/18.
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
     Chaining method to set errorMessage to error object using `.custom(errorMessage: String)`.
     - parameter errorMessage: The value to be set.
     - returns: Returns new object with a new error object which has given error message.
     */
    public func with(errorMessage: String) -> Rule {

        var rule = self
        rule.error = ValidationError.custom(errorMessage: errorMessage)
        return rule
    }
}
