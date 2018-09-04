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

// TODO: Add documentation

public typealias ValidationHandler = ((Result) -> Void)

internal struct ValidatorCache {

    private init() { }
    internal static var rules: [Int: [Rule]] = [:]
    internal static var validationHandlers: [Int: ValidationHandler] = [:]
    internal static var validValues: [Int: Any] = [:]
    internal static var formHandlers: [Int: ValidationHandler] = [:]
}
