//
//  CharacterSetRule.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 9/6/18.
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

/// Character set rule to check if the input string contains chars from the passed in set.
public struct CharacterSetRule: Rule {

    /// Mode of rule execution.
    public enum Mode {

        /// Checks if the string contains elements from charset between `min` and `max` repetetions.
        case contains(min: Int, max: Int)
        /// Checks if the entire string is made up of character set elements.
        case containsOnly
        /// Checks if the string does not contains any character set elements.
        case doesNotContain
    }

    private let characterSet: CharacterSet
    private let mode: Mode
    private let ignoreCharacterSet: CharacterSet?
    /// Error to be returned if validation fails.
    public var error: Error

    /**
     Initialiser.

     - parameter characterSet: Character set object from which the string has to check for elements.
     - parameter mode: Mode of rule execution. Default is `contains` between `1` and `Int.max`.
     - parameter ignoreCharactersIn: Characterset of which all characters will be ignored from the
     input string before validation.
     - parameter error: Error to be returned in case of validation failure.
     Default is `characterSetError`
     */
    public init(
        characterSet: CharacterSet,
        mode: Mode = .contains(min: 1, max: Int.max),
        ignoreCharactersIn ignoreCharacterSet: CharacterSet? = nil,
        error: Error = ValidationError.characterSetError
        ) {

        self.characterSet = characterSet
        self.mode = mode
        self.ignoreCharacterSet = ignoreCharacterSet
        self.error = error
    }

    /**
     Validation implementation method.

     - parameter value: The value to be passed in for validation.
     - returns: A result object with success or failure with errors.

     - note: Checks if the passed in `value` and the character set elements has relations mentioned
     using mode.
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

        var isValid = false
        switch mode {
        case let .contains(minimum, maximum):
            let count = numberOfOccurences(inString: valueToBeValidated, of: characterSet)
            isValid = (minimum...maximum ~= count)
        case .containsOnly:
            isValid = valueToBeValidated.rangeOfCharacter(from: characterSet.inverted) == nil
            // This is to fail strings with characters only from ignored set.
            if (valueToBeValidated.count != inputValue.count) && valueToBeValidated.isEmpty {
                isValid = false
            }
        case .doesNotContain:
            isValid = valueToBeValidated.rangeOfCharacter(from: characterSet) == nil
        }

        return isValid ? Result.succeed(valueToBeValidated) : Result.fail(valueToBeValidated, withErrors: [error])
    }

    private func numberOfOccurences(inString string: String, of characterSet: CharacterSet) -> Int {

        var count = 0
        var range = string.startIndex..<string.endIndex
        while let foundRange = string.rangeOfCharacter(from: characterSet, options: [], range: range),
            !foundRange.isEmpty {
                range = foundRange.upperBound..<string.endIndex
                count += 1
        }
        return count
    }
}

extension CharacterSetRule {

    /**
     Factory method to create rule which checks if the string contains digits in `min`...`max` range.

     - parameter min: Minimum number of digits needed. Default is `1`
     - parameter max: Maximum number of digits allowed. Default is `255`
     - parameter error: Error object to be returned in case of validation failure. Default is
     `occurrencesNotInRange` error.

     - note: Maximum value allowed for max is 255. `min` must be less than or equal to `max`.
     */
    public static func containsNumber(
        minimum: Int = 1,
        maximum: Int = Int.max,
        error: Error = ValidationError.occurrencesNotInRange
        ) -> CharacterSetRule {

        return CharacterSetRule(
            characterSet: .decimalDigits,
            mode: .contains(min: minimum, max: maximum),
            error: error
        )
    }

    /**
     Factory method to create rule which checks if the string contains uppercase chars in
     `min`...`max` range.

     - parameter min: Minimum number of uppercase chars needed. Default is `1`
     - parameter max: Maximum number of uppercase chars allowed. Default is `255`
     - parameter error: Error object to be returned in case of validation failure. Default is
     `occurrencesNotInRange` error.

     - note: Maximum value allowed for max is 255. `min` must be less than or equal to `max`.
     */
    public static func containsUpperCase(
        minimum: Int = 1,
        maximum: Int = Int.max,
        error: Error = ValidationError.occurrencesNotInRange
        ) -> CharacterSetRule {

        return CharacterSetRule(
            characterSet: .uppercaseLetters,
            mode: .contains(min: minimum, max: maximum),
            error: error
        )
    }

    /**
     Factory method to create rule which checks if the string contains lowercase chars in
     `min`...`max` range.

     - parameter min: Minimum number of lowercase chars needed. Default is `1`
     - parameter max: Maximum number of lowercase chars allowed. Default is `255`
     - parameter error: Error object to be returned in case of validation failure. Default is
     `occurrencesNotInRange` error.

     - note: Maximum value allowed for max is 255. `min` must be less than or equal to `max`.
     */
    public static func containsLowerCase(
        minimum: Int = 1,
        maximum: Int = Int.max,
        error: Error = ValidationError.occurrencesNotInRange
        ) -> CharacterSetRule {

        return CharacterSetRule(
            characterSet: .lowercaseLetters,
            mode: .contains(min: minimum, max: maximum),
            error: error
        )
    }

    /**
     Factory method to create rule which checks if the string contains symbol chars in
     `min`...`max` range.

     - parameter min: Minimum number of symbol chars needed. Default is `1`
     - parameter max: Maximum number of symbol chars allowed. Default is `255`
     - parameter error: Error object to be returned in case of validation failure. Default is
     `occurrencesNotInRange` error.

     - note: Maximum value allowed for max is 255. `min` must be less than or equal to `max`.
     */
    public static func containsSymbols(
        minimum: Int = 1,
        maximum: Int = Int.max,
        error: Error = ValidationError.occurrencesNotInRange
        ) -> CharacterSetRule {

        return CharacterSetRule(
            characterSet: .symbols,
            mode: .contains(min: minimum, max: maximum),
            error: error
        )
    }

    /**
     Factory method to create rule which checks for strings with numbers only.

     - parameter ignoreCharactersIn: Characterset of which all characters will be ignored from the
     input string before validation.
     */
    public static func numbersOnly(
        ignoreCharactersIn characterSet: CharacterSet? = nil
        ) -> CharacterSetRule {

        return CharacterSetRule(
            characterSet: .decimalDigits,
            mode: .containsOnly,
            ignoreCharactersIn: characterSet,
            error: ValidationError.invalidType
        )
    }

    /**
     Factory method to create rule which checks for strings with uppercase chars only.

     - parameter ignoreCharactersIn: Characterset of which all characters will be ignored from the
     input string before validation.
     */
    public static func upperCaseOnly(
        ignoreCharactersIn characterSet: CharacterSet? = nil
        ) -> CharacterSetRule {

        return CharacterSetRule(
            characterSet: .uppercaseLetters,
            mode: .containsOnly,
            ignoreCharactersIn: characterSet,
            error: ValidationError.invalidType
        )
    }

    /**
     Factory method to create rule which checks for strings with lowercase chars only.

     - parameter ignoreCharactersIn: Characterset of which all characters will be ignored from the
     input string before validation.
     */
    public static func lowerCaseOnly(
        ignoreCharactersIn characterSet: CharacterSet? = nil
        ) -> CharacterSetRule {

        return CharacterSetRule(
            characterSet: .lowercaseLetters,
            mode: .containsOnly,
            ignoreCharactersIn: characterSet,
            error: ValidationError.invalidType
        )
    }
}
