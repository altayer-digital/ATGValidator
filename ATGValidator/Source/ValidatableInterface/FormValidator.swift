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

// TODO: Add documentation

public class FormValidator {

    private var elements: [ValidatableInterface] = []
    private var status: [Int: Result] = [:]

    public var handler: ValidationHandler?
    public init(handler: ValidationHandler? = nil) {

        self.handler = handler
    }
}

extension FormValidator {

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

    public func remove<V: ValidatableInterface>(_ element: V) where V: Equatable & Hashable {

        elements = elements.filter({ ($0 as? V) != element })
        element.formHandler = nil
    }

    public func validateForm() {

        var formResult = Result.succeed(self)
        for item in self.status.values {
            formResult = formResult.merge(item)
        }
        self.handler?(formResult)
    }
}
