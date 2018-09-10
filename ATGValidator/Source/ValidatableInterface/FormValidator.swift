//
//  FormValidator.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 9/3/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
//

/// Form validator to handle validation of collection of UI elements.
public class FormValidator {

    private var elements: [ValidatableInterface] = []
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
     */
    public func add<V: ValidatableInterface>(_ element: V) where V: Equatable & Hashable {

        if !elements.contains(where: { ($0 as? V) == element}) {

            elements.append(element)

            element.formHandler = { result in

                self.status[element.hashValue] = result
                self.validateForm()
            }

            if let rules = ValidatorCache.rules[element.hashValue] {
                self.status[element.hashValue] = element.satisfyAll(rules: rules)
            }
        }
    }

    /**
     Method to remove UI components from form validator.

     - parameter element: Value conforming to `ValidatableInterface` protocol. An additional
     requirement is that the element should be conforming to `Equatable` and `Hashable` protocols.
     */
    public func remove<V: ValidatableInterface>(_ element: V) where V: Equatable & Hashable {

        elements = elements.filter({ ($0 as? V) != element })
        element.formHandler = nil
    }

    /**
     Method to manually trigger form validation. The handler will be executed with the validation
     result on calling this method.
     */
    public func validateForm() {

        var formResult = Result.succeed(self)
        for item in self.status.values {
            formResult = formResult.merge(item)
        }
        self.handler?(formResult)
    }
}
