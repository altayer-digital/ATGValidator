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

// TODO: Add documentation

public struct CharacterSetRule: Rule {

    public enum Mode {
        case contains(min: Int, max: Int)
        case containsOnly
        case doesNotContain
    }

    private let characterSet: CharacterSet
    private let mode: Mode
    public var error: Error

    public init(
        characterSet: CharacterSet,
        mode: Mode = .contains(min: 1, max: Int.max),
        error: Error = ValidationError.characterSetError
        ) {

        self.characterSet = characterSet
        self.mode = mode
        self.error = error
    }

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

    public static func containsNumber(minimum: Int = 1, maximum: Int = Int.max) -> CharacterSetRule {

        return CharacterSetRule(
            characterSet: .decimalDigits,
            mode: .contains(min: minimum, max: maximum),
            error: ValidationError.occurrencesNotInRange
        )
    }

    public static func containsUpperCase(minimum: Int = 1, maximum: Int = Int.max) -> CharacterSetRule {

        return CharacterSetRule(
            characterSet: .uppercaseLetters,
            mode: .contains(min: minimum, max: maximum),
            error: ValidationError.occurrencesNotInRange
        )
    }

    public static func containsLowerCase(minimum: Int = 1, maximum: Int = Int.max) -> CharacterSetRule {

        return CharacterSetRule(
            characterSet: .lowercaseLetters,
            mode: .contains(min: minimum, max: maximum),
            error: ValidationError.occurrencesNotInRange
        )
    }

    public static func containsSymbols(minimum: Int = 1, maximum: Int = Int.max) -> CharacterSetRule {

        return CharacterSetRule(
            characterSet: .symbols,
            mode: .contains(min: minimum, max: maximum),
            error: ValidationError.occurrencesNotInRange
        )
    }

    public static let numbersOnly = CharacterSetRule(
        characterSet: .decimalDigits,
        mode: .containsOnly,
        error: ValidationError.invalidType
    )

    public static let upperCaseOnly = CharacterSetRule(
        characterSet: .uppercaseLetters,
        mode: .containsOnly,
        error: ValidationError.invalidType
    )

    public static let lowerCaseOnly = CharacterSetRule(
        characterSet: .lowercaseLetters,
        mode: .containsOnly,
        error: ValidationError.invalidType
    )
}
