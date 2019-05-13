//
//  LengthRule.swift
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

/// String length check rule.
public struct StringLengthRule: Rule {

    private let min: Int
    private let max: Int
    private let trimWhiteSpace: Bool
    private let ignoreCharacterSet: CharacterSet?

    /// Error to be returned if validation fails.
    public var error: Error

    /**
     Initialiser.

     - parameter min: Lower string length limit.
     - parameter max: Upper string length limit.
     - parameter trimWhiteSpace: Whether to trim whitespace and newline from input string before
     validation.
     - parameter ignoreCharactersIn: Characterset of which all characters will be ignored from the
     input string before validation.
     - parameter error: Error to be returned in case of validation failure.
     */
    public init(
        min: Int = 0,
        max: Int = Int.max,
        trimWhiteSpace: Bool = true,
        ignoreCharactersIn characterSet: CharacterSet? = nil,
        error: Error = ValidationError.lengthOutOfRange
        ) {

        self.min = min
        self.max = max
        self.trimWhiteSpace = trimWhiteSpace
        self.ignoreCharacterSet = characterSet
        self.error = error
    }

    /**
     Factory method to create a rule with only minimum length requirement.

     - parameter min: Lower string length limit.
     - parameter trimWhiteSpace: Whether to trim whitespace and newline from input string before
     validation.
     - parameter ignoreCharactersIn: Characterset of which all characters will be ignored from the
     input string before validation.
     - parameter error: Error to be returned in case of validation failure.
     */
    public static func min(
        _ min: Int,
        trimWhiteSpace: Bool = true,
        ignoreCharactersIn characterSet: CharacterSet? = nil,
        error: Error = ValidationError.shorterThanMinimumLength
        ) -> StringLengthRule {

        return StringLengthRule(
            min: min,
            trimWhiteSpace: trimWhiteSpace,
            ignoreCharactersIn: characterSet,
            error: error
        )
    }

    /**
     Factory method to create a required rule requirement.

     - parameter trimWhiteSpace: Whether to trim whitespace and newline from input string before
     validation.
     - parameter ignoreCharactersIn: Characterset of which all characters will be ignored from the
     input string before validation.
     - parameter error: Error to be returned in case of validation failure.
     */
    public static func required(
        trimWhiteSpace: Bool = true,
        ignoreCharactersIn characterSet: CharacterSet? = nil,
        error: Error = ValidationError.shorterThanMinimumLength
        ) -> StringLengthRule {

        return StringLengthRule(
            min: 1,
            trimWhiteSpace: trimWhiteSpace,
            ignoreCharactersIn: characterSet,
            error: error
        )
    }

    /**
     Factory method to create a rule with only maximum length requirement.

     - parameter min: Upper string length limit.
     - parameter trimWhiteSpace: Whether to trim whitespace and newline from input string before
     validation.
     - parameter ignoreCharactersIn: Characterset of which all characters will be ignored from the
     input string before validation.
     - parameter error: Error to be returned in case of validation failure.
     */
    public static func max(
        _ max: Int,
        trimWhiteSpace: Bool = true,
        ignoreCharactersIn characterSet: CharacterSet? = nil,
        error: Error = ValidationError.longerThanMaximumLength
        ) -> StringLengthRule {

        return StringLengthRule(
            max: max,
            trimWhiteSpace: trimWhiteSpace,
            ignoreCharactersIn: characterSet,
            error: error
        )
    }

    /**
     Factory method to create a rule with equal to length requirement.

     - parameter length: Length required.
     - parameter trimWhiteSpace: Whether to trim whitespace and newline from input string before
     validation.
     - parameter ignoreCharactersIn: Characterset of which all characters will be ignored from the
     input string before validation.
     - parameter error: Error to be returned in case of validation failure.
     */
    public static func equal(
        to length: Int,
        trimWhiteSpace: Bool = true,
        ignoreCharactersIn characterSet: CharacterSet? = nil,
        error: Error = ValidationError.notEqual
        ) -> StringLengthRule {

        return StringLengthRule(
            min: length,
            max: length,
            trimWhiteSpace: trimWhiteSpace,
            ignoreCharactersIn: characterSet,
            error: error
        )
    }

    /**
     Validation implementation method.

     - parameter value: The value to be passed in for validation.
     - returns: A result object with success or failure with errors.

     - note: Checks if the passed in `value`'s length is between `min` and `max` both including.
     */
    public func validate(value: Any) -> Result {

        guard let inputValue = value as? String else {

            return Result.fail(value, withErrors: [ValidationError.invalidType])
        }

        var valueToBeValidated = inputValue

        if let characterSet = ignoreCharacterSet {
            let passed = valueToBeValidated.unicodeScalars.filter { !characterSet.contains($0) }
            valueToBeValidated = String(String.UnicodeScalarView(passed))
        }
        if trimWhiteSpace {
            valueToBeValidated = valueToBeValidated.trimmingCharacters(
                in: CharacterSet.whitespacesAndNewlines
            )
        }

        let isValid = valueToBeValidated.count >= min && valueToBeValidated.count <= max

        return isValid ? Result.succeed(inputValue) : Result.fail(inputValue, withErrors: [error])
    }
}
