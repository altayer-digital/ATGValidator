//
//  ValidationError.swift
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

/// Default validation error group used.
public enum ValidationError: Error {

    case invalidType
    case notEqual
    case equal
    case shorterThanMinimumLength
    case longerThanMaximumLength
    case lengthOutOfRange
    case valueOutOfRange
    case regexMismatch
    case invalidEmail
    case numberNotFound
    case lowerCaseNotFound
    case upperCaseNotFound
    case invalidPaymentCardNumber
    case paymentCardNotSupported
    case characterSetError
    case occurrencesNotInRange
    case custom(errorMessage: String)

    public var customErrorMessage: String? {
        switch self {
        case .custom(let errorMessage):
            return errorMessage
        default:
            return nil
        }
    }
}

// MARK: - ValidationError: Equatable

extension ValidationError: Equatable {}
