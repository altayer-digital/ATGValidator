//
//  FormValidator.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 9/3/18.
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

/// Form validator to handle validation of collection of UI elements.
public class FormValidator {

    /**
     Auto validation policy for the fields to be mentioned while adding them to the form.

     ```
     case never
     case onInputChange
     case onFocusLoss
     ```
    */
    public enum AutoValidationPolicy {

        /// Do not auto-validate.
        case never
        /// Auto-validate on input changes.
        case onInputChange
        /// Auto-validate on losing focus from field.
        case onFocusLoss
    }

    private var elements: [Int: ValidatableInterface] = [:]
    private var status: [Int: Result] = [:]

    /// Validation handler closure to be executed on validation status change.
    public var handler: ValidationHandler?
    /**
     Initializer

     - parameter handler: Validation handler object to be called on validation status change.
     */
    public init(handler: ValidationHandler? = nil) {

        self.handler = handler
    }
}

extension FormValidator {

    /**
     Method to add UI components to the form validator.

     - parameter element: Value conforming to `ValidatableInterface` protocol. An additional
     requirement is that the element should be conforming to `Equatable` and `Hashable` protocols.
     - parameter policy: Auto-validation policy for the added field. Please note that the field
     will be validated on calling `validateForm`.
     */
    public func add<V: ValidatableInterface>(
        _ element: V,
        policy: AutoValidationPolicy = .onFocusLoss
        ) where V: Hashable {

        if !elements.keys.contains(element.hashValue) {

            elements[element.hashValue] = element

            switch policy {
            case .onInputChange:
                element.validateOnInputChange(true)
            case .onFocusLoss:
                element.validateOnFocusLoss(true)
            case .never:
                break
            }

            element.formHandler = { result in

                self.status[element.hashValue] = result
                self.processFormResults()
            }

            if let rules = element.validationRules {
                self.status[element.hashValue] = element.satisfyAll(rules: rules)
            }
        }
    }

    /**
     Method to remove UI components from form validator.

     - parameter element: Value conforming to `ValidatableInterface` protocol. An additional
     requirement is that the element should be conforming to `Equatable` and `Hashable` protocols.
     */
    public func remove<V: ValidatableInterface>(_ element: V) where V: Hashable {

        elements.removeValue(forKey: element.hashValue)
        if element.validationHandler == nil {
            element.validateOnInputChange(false)
            element.validateOnFocusLoss(false)
        }
        element.formHandler = nil
    }

    /**
     Method to manually trigger form validation. The handler will be executed with the validation
     result on calling this method.

     All the input fields will call `satisfyAll:` with their respective rules.

     - parameter shouldInvokeElementHandlers: If set to `true`, all fields will call their
     validation handlers with corresponding result object. Default is `true`.
     */
    public func validateForm(
        shouldInvokeElementHandlers: Bool = true,
        completion: ValidationHandler? = nil
        ) {

        for (hash, element) in elements {
            if let rules = ValidatorCache.rules[hash] {
                let result = element.satisfyAll(rules: rules)
                self.status[hash] = result
                if shouldInvokeElementHandlers,
                    let handler = ValidatorCache.validationHandlers[hash] {
                    handler(result)
                }
            }
        }
        processFormResults(completion: completion)
    }

    private func processFormResults(completion: ValidationHandler? = nil) {

        var formResult = Result.succeed(self)
        for item in self.status.values {
            formResult = formResult.merge(item)
        }
        self.handler?(formResult)
        completion?(formResult)
    }
}
