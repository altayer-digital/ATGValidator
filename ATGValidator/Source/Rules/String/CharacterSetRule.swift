//
//  CharacterSetRule.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 9/6/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
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
    /// Error to be returned if validation fails.
    public var error: Error

    /**
     Initialiser.

     - parameter characterSet: Character set object from which the string has to check for elements.
     - parameter mode: Mode of rule execution. Default is `contains` between `1` and `Int.max`.
     - parameter error: Error to be returned in case of validation failure.
     Default is `characterSetError`
     */
    public init(
        characterSet: CharacterSet,
        mode: Mode = .contains(min: 1, max: Int.max),
        error: Error = ValidationError.characterSetError
        ) {

        self.characterSet = characterSet
        self.mode = mode
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

        var isValid = false
        switch mode {
        case let .contains(minimum, maximum):
            let count = numberOfOccurences(inString: inputValue, of: characterSet)
            isValid = (minimum...maximum ~= count)
        case .containsOnly:
            isValid = inputValue.rangeOfCharacter(from: characterSet.inverted) == nil
        case .doesNotContain:
            isValid = inputValue.rangeOfCharacter(from: characterSet) == nil
        }

        return isValid ? Result.succeed(inputValue) : Result.fail(inputValue, withErrors: [error])
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

    /// Factory instance to create rule which checks for strings with numbers only.
    public static let numbersOnly = CharacterSetRule(
        characterSet: .decimalDigits,
        mode: .containsOnly,
        error: ValidationError.invalidType
    )

    /// Factory instance to create rule which checks for strings with uppercase chars only.
    public static let upperCaseOnly = CharacterSetRule(
        characterSet: .uppercaseLetters,
        mode: .containsOnly,
        error: ValidationError.invalidType
    )

    /// Factory instance to create rule which checks for strings with lowercase chars only.
    public static let lowerCaseOnly = CharacterSetRule(
        characterSet: .lowercaseLetters,
        mode: .containsOnly,
        error: ValidationError.invalidType
    )
}
