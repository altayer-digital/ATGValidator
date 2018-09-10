//
//  ValidatorCache.swift
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
    internal static var validValues: [Int: Any] = [:]
    internal static var formHandlers: [Int: ValidationHandler] = [:]
}
