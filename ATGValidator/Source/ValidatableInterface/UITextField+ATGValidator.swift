//
//  UITextField+ATGValidator.swift
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

extension UITextField: ValidatableInterface {

    public var inputValue: Any {
        return text ?? ""
    }

    public func validateOnInputChange(_ validate: Bool) {
        switch validate {
        case true:
            addTarget(self, action: #selector(validateTextField), for: .editingChanged)
        case false:
            removeTarget(self, action: #selector(validateTextField), for: .editingChanged)
        }
    }

    @objc private func validateTextField(sender: UITextField) {

        guard let rules = ValidatorCache.rules[sender.hashValue] else {
            return
        }

        var result = sender.satisfyAll(rules: rules)
        if result.status == .success {
            validValue = inputValue
        } else if let value = validValue {
            result.value = value
        }
        let handler = ValidatorCache.validationHandlers[sender.hash]
        handler?(result)
    }
}
