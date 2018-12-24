//
//  ValidationError.swift
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

/// Default validation error group used.
public enum ValidationError: Error {

    case invalidType
    case notEqual
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
}

/// Validation error with custom error messages.
public struct CustomValidationError: LocalizedError {

    private let errorMessage: String?

    public init(_ errorMessage: String?) {
        self.errorMessage = errorMessage
    }

    public var errorDescription: String? {
        return errorMessage
    }
}
