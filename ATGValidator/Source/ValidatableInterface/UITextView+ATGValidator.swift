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

/**
 Extension to UITextView to add support for validation.

 In order to use validation functionality, the user needs to set `validationRules` and
 `validationHandler`. After that the `validateOnInputChange:` method needs to be called on the
 field to enable validation on input events.

 On each input change, the `validationHandler` will be called with current validation status in the
 result object.

 The result object can be checked for status as `success`/`failure` and in case of failure,
 the `errors` array will be populated with all validation errors.

 The `value` variable in the result object will be populated with the last valid value if available,
 or with the input value. If you want to enforce the rules on the textfield with input rejection,
 you can set the `result.value` to the textfield's text variable in handler closure. This will make
 it impossible to enter rule violating characters in the textview.

 On top of this, you can call `satisfyAll:` or `satisfyAny:` directly on the textfield.
 */
extension UITextView: ValidatableInterface {

    public var inputValue: Any {
        return text
    }

    /**
     Enable/Disable validation on input change.

     - parameter validate: Enable/Disable automatic validation.
     */
    public func validateOnInputChange(_ validate: Bool) {

        if validate {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(validateTextView),
                name: UITextView.textDidChangeNotification,
                object: self
            )
        } else {
            NotificationCenter.default.removeObserver(
                self,
                name: UITextView.textDidChangeNotification,
                object: self
            )
        }
    }

    /**
     Enable/Disable validation on focus loss.

     - parameter validate: Enable/Disable automatic validation.
     */
    public func validateOnFocusLoss(_ validate: Bool) {

        if validate {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(validateTextView),
                name: UITextView.textDidEndEditingNotification,
                object: self
            )
        } else {
            NotificationCenter.default.removeObserver(
                self,
                name: UITextView.textDidEndEditingNotification,
                object: self
            )
        }
    }

    /**
     Validates the textview's proeprty.

     This method gets the rules from validator cache, and calls `satisfyAll`. ie, all rules should
     pass to get a success result. If it passes all rules, the input value will be saved as
     validValue. If the result is failure, and a valid value is present, same will be assigned to
     result.value.

     Please remember that both `validationHandler` and `formHandler` needs to be called with the
     result object.
     */
    @objc func validateTextView() {

        guard let rules = validationRules else {
            return
        }

        var result = satisfyAll(rules: rules)
        if result.status == .success {
            validValue = result.value
        } else if let value = validValue {
            result.value = value
        }
        validationHandler?(result)
        formHandler?(result)
    }
}
