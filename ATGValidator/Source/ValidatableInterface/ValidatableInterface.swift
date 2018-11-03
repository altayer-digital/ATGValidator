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

/**
 ValidatableInterface protocol.

 - note: The UI elements (eg: UITextField) should conform to this protocol to get the validation
 support.
 */
public protocol ValidatableInterface: class, Validatable {

    /**
     Method to add/remove event listeners for validation on input change

     - parameter validate: Enable/Disable automatic validation.
     - note: The conforming classes must implement this method, add/remove event listeners for
     input change, and handle validation on the specific input events.
     */
    func validateOnInputChange(_ validate: Bool)

    /**
     Method to add/remove event listeners for validation on focus loss

     - parameter validate: Enable/Disable automatic validation.
     - note: The conforming classes must implement this method, add/remove event listeners for
     focus loss, and handle validation on the specific input events.
     */
    func validateOnFocusLoss(_ validate: Bool)
}

extension ValidatableInterface {

    /// Conforming classes needs to return the value to be validated from this getter.
    public var inputValue: Any {

        fatalError("Over ride this getter to return the value to be validated.!")
    }
}

extension ValidatableInterface where Self: Hashable {

    /// Variable to maintain last valid value.
    public var validValue: Any? {
        get {
            return ValidatorCache.validValues[self.hashValue]
        }
        set {
            ValidatorCache.validValues[self.hashValue] = newValue
        }
    }

    /// Validation rules set on the interface.
    public var validationRules: [Rule]? {
        get {
            return ValidatorCache.rules[self.hashValue]
        }
        set {
            ValidatorCache.rules[self.hashValue] = newValue
        }
    }

    /**
     Validation handler to be executed on changes in validation state. This will be called only if
     the `validateOnInputChange` is called with true.
     */
    public var validationHandler: ValidationHandler? {
        get {
            return ValidatorCache.validationHandlers[self.hashValue]
        }
        set {
            ValidatorCache.validationHandlers[self.hashValue] = newValue
        }
    }

    /**
     Validation handler to be executed on changes in validation state. This will be called only if
     the interface element is added to a form validator.
     */
    public var formHandler: ValidationHandler? {
        get {
            return ValidatorCache.formHandlers[self.hashValue]
        }
        set {
            ValidatorCache.formHandlers[self.hashValue] = newValue
        }
    }

    /// Method to clean up all validation related structs and closures.
    public func cleanUpFromValidatorCache() {

        validValue = nil
        validationRules = nil
        validationHandler = nil
        formHandler = nil
    }
}
