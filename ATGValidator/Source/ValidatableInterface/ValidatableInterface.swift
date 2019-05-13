//
//  ValidatableInterface.swift
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
