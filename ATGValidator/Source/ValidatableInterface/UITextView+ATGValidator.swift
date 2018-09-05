//
//  UITextView+ATGValidator.swift
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

// TODO: Add documentation

extension UITextView: ValidatableInterface {

    public var inputValue: Any {
        return text
    }

    public func validateOnInputChange(_ validate: Bool) {

        if validate {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(validateTextView),
                name: .UITextViewTextDidChange,
                object: self
            )
        } else {
            NotificationCenter.default.removeObserver(
                self,
                name: .UITextViewTextDidChange,
                object: self
            )
        }
    }

    @objc private func validateTextView() {

        guard let rules = ValidatorCache.rules[hashValue] else {
            return
        }

        var result = satisfyAll(rules: rules)
        if result.status == .success {
            validValue = result.value
        } else if let value = validValue {
            result.value = value
        }
        let handler = ValidatorCache.validationHandlers[hashValue]
        handler?(result)
        formHandler?(result)
    }
}
