//
//  Validatable.swift
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

/// Validatable protocol. To be conformed by classes that needs to be validated.
public protocol Validatable {

    /// Return the value to be validated in this variable.
    var inputValue: Any { get }
    /**
     Method to validate all rules. Result is success if all the rules in array succeed.

     - parameter rules: Array of rules to be validated.
     - returns: Result object of the validation.
     */
    func satisfyAll(rules: [Rule]) -> Result
    /**
     Method to validate atleast one of the rules.  Result is success if any of the rules in array
     succeed.

     - parameter rules: Array of rules to be validated.
     - returns: Result of the validation.
     */
    func satisfyAny(rules: [Rule]) -> Result
}

extension Validatable {

    public var inputValue: Any {
        return self
    }

    public func satisfyAll(rules: [Rule]) -> Result {

        var result = Result.succeed(inputValue)

        rules.forEach({ result = result.and($0) })

        return result
    }

    public func satisfyAny(rules: [Rule]) -> Result {

        var result = Result.fail(inputValue)

        rules.forEach({ result = result.or($0) })

        return result
    }
}

extension String: Validatable {}
extension Bool: Validatable {}
extension Int: Validatable {}
extension Double: Validatable {}
extension Float: Validatable {}
extension Array: Validatable {}
extension Date: Validatable {}
