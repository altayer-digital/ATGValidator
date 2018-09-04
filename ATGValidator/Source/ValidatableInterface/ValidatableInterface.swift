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

// TODO: Add documentation

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
            ValidatorCache.validValues[self.hashValue] = newValue
        }
    }

    public var validationRules: [Rule]? {
        get {
            return ValidatorCache.rules[self.hashValue]
        }
        set {
            ValidatorCache.rules[self.hashValue] = newValue
        }
    }

    public var validationHandler: ValidationHandler? {
        get {
            return ValidatorCache.validationHandlers[self.hashValue]
        }
        set {
            ValidatorCache.validationHandlers[self.hashValue] = newValue
        }
    }

    internal var formHandler: ValidationHandler? {
        get {
            return ValidatorCache.formHandlers[self.hashValue]
        }
        set {
            ValidatorCache.formHandlers[self.hashValue] = newValue
        }
    }

    public func cleanUpFromValidatorCache() {

        validValue = nil
        validationRules = nil
        validationHandler = nil
        formHandler = nil
    }
}
