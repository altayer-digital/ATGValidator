# ATGValidator

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/ATGValidator.svg)](https://cocoapods.org/pods/ATGValidator)
[![GitHub issues](https://img.shields.io/github/issues/altayer-digital/ATGValidator.svg)](https://github.com/altayer-digital/ATGValidator/issues)
[![GitHub license](https://img.shields.io/github/license/altayer-digital/ATGValidator.svg)](https://github.com/altayer-digital/ATGValidator/blob/master/LICENSE.md)

ATGValidator is a validation framework written to address most common issues faced while verifying user input data. 

You can use it to validate different data types directly, or validate ui components like UITextfield or UITextView, or even add validation support to your custom UI elements. You don't need to subclass native components to get the validation support. UITextField and UITextView has the support out of the box, adding support for any other elements is as simple as adding an extension with protocol conformance to `ValidatableInterface`.

Best of all, you will get a **form validator** which consolidates validation results of all ui components added to it.

## Basic Usage

You can validate common data types out of the box as illustrated below;

```swift
"Example with 1 number".satisfyAll(rules: [CharacterSetRule.containsNumber()]).status   // success
"Example with more than 20 characters".satisfyAll(rules: [StringLengthRule.max(20)]).status       // failure
472.satisfyAll(rules: [EqualityRule(value: 472.5)])                                     // failure
301.satisfyAny(rules: [RangeRule(min: 200, max: 299), EqualityRule(value: 304)])        // failure
200.satisfyAny(rules: [RangeRule(min: 200, max: 299), EqualityRule(value: 304)])        // success
```

As for validating contents of a ui component, please see the example below;

```swift
textfield.validationRules = [CharacterSetRule.lowerCaseOnly(ignoreCharactersIn: .whitespaces)]
textfield.validationHandler = { result in
    // This block will be executed with relevant result whenever validation is done.
    print(result.status)    // success
}
// Below line is to manually trigger validation.
textfield.validateTextField()
```

In order to use form validator, we need to create a `FormValidator` instance and add required ui elements to the form validator. We can either call the validateForm method directly, or associate a handler closure to the form validator, which will be called when any of the added ui elements' value changes.
```swift
let formValidator = FormValidator()
formValidator.add(textfield)
// Add more ui elements here.
formValidator.validateForm { result in
    print(result)
}
```
<p><span style="color:red">Please read-on below for detailed documentation.</span>.</p>

## Installation

#### Carthage

`ATGValidator` can be installed using [Carthage](https://github.com/Carthage/Carthage). To do so simply add the following line to your `Cartfile`;

```
github "altayer-digital/ATGValidator" ~> 1.0.0
```

#### Cocoapods

To use `ATGValidator` with cocoapods, add the following line to the `Podfile`;

```
pod 'ATGValidator', '~> 1.0'
```
## Usage
First step to add validation is to set the validation rules on the ui element. Any UI element conforming to `ValidatableInterface` accepts an array of rules.
```swift
textfield.validationRules = [
    CharacterSetRule.containsUpperCase(),
    CharacterSetRule.containsLowerCase(),
    CharacterSetRule.containsNumber(),
    CharacterSetRule.containsSymbols()
]
```

In order to validate a single textfield or textview, you can set a `validationHandler` closure on the textfield/textview. This will be executed whenever validation is done on the field and result is ready to be applied. An array of errors are passed with result object if the validation result is a failure.
```swift
textfield.validationHandler = { result in
    print(result.status, result.errors)
}
```
You can call `validateOnInputChange` or `validateOnFocusLoss` on the ui element to make it perform validations on the corresponding events.
```swift
textfield.validateOnInputChange(true)
textfield.validateOnFocusLoss(true)
```

If you need to aggregate validations of multiple ui elements, you need to create a `FormValidator` instance, and add all needed elements to the form validator.
```swift
let formValidator = FormValidator(handler: { result in
    print(result.status, result.errors)
})
formValidator.add(textfield)
```
When adding an item to form validator, by default validation will be done on focus loss on those items. But you can change this behaviour for individual fields by mentioning validationPolicy while adding the item to form validator.
```swift
formValidator.add(textfield, policy: .onInputChange) // or .onFocusLoss or .none
```
Whenever the fields have corresponding state changes to their data, form validator's handler closure will be executed with aggregated results automatically.

If you want to perform validation on-demand, you can use the method `validateForm(shouldInvokeElementHandlers:completion:)` to do it as and when you need it.

## Rules
There are 6 types of rules readily available with the framework out of the box. For all rules you can set a custom error while initializing, or call helper methods `with(error:)->Rule` or `with(errorMessage:)->Rule` to set it later. If not, all rules have their own default errors from `ValidationError` enum. You can find them below with each rule description.

#### EqualityRule
This rule is used to check if the value of the type is equal to the supplied value.

You can create an equality rule by passing the value to be checked against, to the initializer. Optionally you can pass in the mode (`equal`, `notEqual`) and an error object to be returned in case of validation failure.
```swift
let rule = EqualityRule(value: "text_to_be_verified")
// or 
let rule = EqualityRule(value: "shouldn't_be_equal_text", mode: .notEqual, error: ValidationError.equal)
```
Default errors: 
* `notEqual` error for `equal` mode.
* `equal` error for `notEqual` mode.

#### RangeRule
You can check if a value is in a specific range with this rule.

```swift
let rangeRule = RangeRule(min: 200, max: 299)
```
Default error: `valueOutOfRange`

#### StringLengthRule
You can check for a string's length conformance using this rule. You can pass in whether to trim white spaces and to ignore specific charactersets.
```swift
let lengthInRangeRule = StringLengthRule(min: 5, max: 10, trimWhiteSpace: true, ignoreCharactersIn: CharacterSet.symbols)
let minLengthRule = StringLengthRule.min(5)
let maxLengthRule = StringLengthRule.max(5)
let equalLengthRule = StringLengthRule.equal(to: 6)
let requiredStringRule = StringLengthRule.required()
```
Default errors: 
* default: `lengthOutOfRange`
* min: `shorterThanMinimumLength`
* max: `longerThanMaximumLength`
* equal: `notEqual`
* required: `shorterThanMinimumLength`

#### StringRegexRule
This rule allows you to perform regular expression matching on strings. You can optionally pass in whether to trim white spaces.
```swift
let regexRule = StringRegexRule(regex: "^[0-9]*$")
let emailRule = StringRegexRule.email
let containsNumber = StringRegexRule.containsNumber()
let containsNumbersMinMax = StringRegexRule.containsNumber(min: 2, max: 4)
let containsUpperCase = StringRegexRule.containsUpperCase()
let containsUpperCaseMinMax = StringRegexRule.containsUpperCase(min: 1, max: 2)
let containsLowerCase = StringRegexRule.containsLowerCase()
let containsLowerCaseMinMax = StringRegexRule.containsLowerCase(min: 1, max: 2)
let numbersOnly = StringRegexRule.numbersOnly
let lowerCaseOnly = StringRegexRule.lowerCaseOnly
let upperCaseOnly = StringRegexRule.upperCaseOnly
```
Default errors: 
* default: `regexMismatch`
* email: `invalidEmail`
* containsNumber: `numberNotFound`
* containsUpperCase: `upperCaseNotFound`
* containsLowerCase: `lowerCaseNotFound`
* numbersOnly: `invalidType`
* lowerCaseOnly: `invalidType`
* upperCaseOnly: `invalidType`

#### StringValueMatchRule
You can use this rule to check if values from 2 textfields are same. An ideal example is when we check if password field and confirm password field have same contents.
```swift
let passwordTextfield: UITextField?
let confirmPasswordTextfield: UITextField?
let valueMatchRule = StringValueMatchRule(base: passwordTextfield)
confirmPasswordTextfield.validationRules = [valueMatchRule]
```
Default error: `notEqual`

#### PaymentCardRule
Payment card rule can be used to check if a supplied card number is a valid payment card number. Luhn's algorithm in combination with regex matching is used to check the validity of the provided card numbers. The rule can be initiated with card types to be checked for, or if not passed will check for all available card types. Available card types are;
* American Express
* MasterCard
* Maestro
* Visa
* Visa Electron
* Discover
* Diners Club

```swift
let cardRule = PaymentCardRule(acceptedTypes: [.amex, .mastercard, .visa, .discover])
// or
let cardRule = PaymentCardRule()
textfield.validationRules = [cardRule]
textfield.validationHandler = { result in
    if let suggestedType = result.value as? PaymentCardType {
        // This is a suggestion from the framework from the input you entered.
        // Please note that having a suggested card type does not mean it's validation is success.
        // You need to handle success/failure separately outside this confition.
    }
}
textfield.validateOnInputChange(true)
```
Default errors:
* If card number is not valid: `invalidPaymentCardNumber`
* If card number is valid, but is not one of the accepted types: `paymentCardNotSupported`

In order to identify the card type while you are typing in the number, please use the `value` field in `Result` object. If a card type can be suggested from the entered input, the rule will populate the `Result.value` field with the card type, else it will be populated with the input.
Please note that a minimum of 4 characters needs to be entered before the rule starts finding card type suggestions.

## Advanced Usage

### Validatable
 Validatable is the base protocol which is conformed by any data type that can be validated. Most commonly used types in Swift conforms to Validatable out-of-the-box. Below is the list of all data types that conforms to Validatable out-of-the-box.

 * String
 * Bool
 * Int
 * Double
 * Float
 * CGFloat
 * Date

If you want to add validation support to any other types, you can do so by conforming it to the validatable protocol.

### ValidatableInterface
If any custom UI element needs to support validation, it needs to conform to `ValidatableInterface` protocol. Out of the box, ATGValidator has added this conformance to `UITextField` and `UITextView`. Please note that the `ValidatableInterface` protocol conforms to `Validatable` protocol. Please see the example for `UITextField` below to understand how the conformance needs to be implemented.
```swift
extension UITextField: ValidatableInterface {

    public var inputValue: Any {
        return text ?? ""
    }

    public func validateOnInputChange(_ validate: Bool) {

        if validate {
            addTarget(self, action: #selector(validateTextField), for: .editingChanged)
        } else {
            removeTarget(self, action: #selector(validateTextField), for: .editingChanged)
        }
    }

    public func validateOnFocusLoss(_ validate: Bool) {

        if validate {
            addTarget(self, action: #selector(validateTextField), for: .editingDidEnd)
            addTarget(self, action: #selector(validateTextField), for: .editingDidEndOnExit)
        } else {
            removeTarget(self, action: #selector(validateTextField), for: .editingDidEnd)
            removeTarget(self, action: #selector(validateTextField), for: .editingDidEndOnExit)
        }
    }

    @objc public func validateTextField() {

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
```

## Custom Errors
`ValidationError` is an enum that holds all default validation errors. If you don't want to define an additional error object, and just needs a custom validation error string to be passed, please use `ValidationError.custom(errorMessage: String)` for it. 
There are couple of helper methods in `Rule` to set custom errors easily. They are as given below;
```swift
var emailRule = StringRegexRule.email
emailRule = emailRule.with(error: CustomErrorThatConformsToErrorProtocol())
// or
emailRule = emailRule.with(errorMessage: "Email is not correct..!")

```

## ValidatorCache
This is a custom in memory storage used to hold all rules, valid values, form handler and validation handlers closures. Please feel free to explore how it is implemented.

## Due Credits

When we were faced with the task of finding a good validation framework to be used in our apps, we went through the exploration stage to find available opensource libraries and finally came up with the best one available for the job. If you were in the same situation, you must know which one it is. It's none other than the amazing [Validator](https://github.com/adamwaite/Validator) framework written by [Adam Waite](https://github.com/adamwaite). If you haven't seen it already, please head over to that repo and take a look.

[Validator](https://github.com/adamwaite/Validator) uses generics extensively and is the backbone of how the framework works. This made it impossible for us to club together various ui elements and get a unified result for the validations from them. And we really needed form validation in our projects. 

So we started writing a framework with protocols as its backbone and to use form validation as the main goal we wanted to achieve. And here is the result, ATGValidator. Please note that the core concepts are heavily influenced by [Validator](https://github.com/adamwaite/Validator) framework and we want to give the due credit to [Adam Waite](https://github.com/adamwaite) for the excellent work he has done.

## Copyright and License

ATGValidator is available under the MIT license. See [`LICENSE.md`](https://github.com/altayer-digital/ATGValidator/blob/master/LICENSE.md) for more information.

## Contributors

[List of contributors is available through GitHub.](https://github.com/altayer-digital/ATGValidator/graphs/contributors)
