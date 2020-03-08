//
//  ValidatorCache.swift
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

/**
 Validation handler closure.
 - parameter result: The result of the validation action.
 - note: The validation handler is called by `ValidatableInterface` or `FormValidator` on changes in
 the validation state of specific fields.
 */
public typealias ValidationHandler = ((Result) -> Void)

/**
 Cache used to maintain mapping between rules, validation handlers, valid values and form handlers
 with their corresponding UI elements. This is an in-memory cache and will be cleared on app kill.
 */
internal struct ValidatorCache {

    private init() { }
    internal static var rules: [Int: [Rule]] = [:]
    internal static var validationHandlers: [Int: ValidationHandler] = [:]
    internal static var formHandlers: [Int: ValidationHandler] = [:]
}
