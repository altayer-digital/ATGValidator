//
//  ValidatableInterface.swift
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

public protocol ValidatableInterface: class, Validatable {

    func validateOnInputChange(_ validate: Bool)
}

extension ValidatableInterface {

    public var inputValue: Any {
        fatalError("Over ride this getter to return the value to be validated.!")
    }
}

extension ValidatableInterface where Self: Hashable {

    internal var validValue: Any? {
        get {
            return ValidatorCache.validValues[self.hashValue]
        }
        set {
            if let value = newValue {
                ValidatorCache.validValues[self.hashValue] = value
            }
        }
    }

    public var validationRules: [Rule]? {
        get {
            return ValidatorCache.rules[self.hashValue]
        }
        set {
            if let rules = newValue {
                ValidatorCache.rules[self.hashValue] = rules
            }
        }
    }

    public var validationHandler: ValidationHandler? {
        get {
            return ValidatorCache.validationHandlers[self.hashValue]
        }
        set {
            if let handler = newValue {
                ValidatorCache.validationHandlers[self.hashValue] = handler
            }
        }
    }
}
