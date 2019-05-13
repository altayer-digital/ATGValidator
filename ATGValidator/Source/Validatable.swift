//
//  Validatable.swift
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

        var result = Result.fail(inputValue, withErrors: [])

        rules.forEach({ result = result.or($0) })

        return result
    }
}

extension String: Validatable {}
extension Bool: Validatable {}
extension Int: Validatable {}
extension Double: Validatable {}
extension Float: Validatable {}
extension CGFloat: Validatable {}
extension Array: Validatable {}
extension Date: Validatable {}
