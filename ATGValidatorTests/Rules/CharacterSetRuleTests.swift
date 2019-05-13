//
//  CharacterSetRuleTests.swift
//  ATGValidatorTests
//
//  Created by Suraj Thomas K on 9/16/18.
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

import XCTest
@testable import ATGValidator

class CharacterSetRuleTests: XCTestCase {

    func testInvalidType() {

        let testValue = 34
        let characterSet = CharacterSet.alphanumerics

        let rule = CharacterSetRule(characterSet: characterSet)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidType])
        XCTAssertEqual(result.value as? Int, testValue)
    }

    func testContains() {

        let characterSet = CharacterSet.uppercaseLetters
        let rule = CharacterSetRule(characterSet: characterSet, mode: .contains(min: 5, max: 7))

        var testValue = "A String With 6 UpperCase Letters.!"
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "A string with 1 uppercase letter.!"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.characterSetError])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "A STRING FULL OF UPPERCASE LETTERS.!"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.characterSetError])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.characterSetError])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testContainsOnly() {

        let characterSet = CharacterSet.lowercaseLetters
        let rule = CharacterSetRule(characterSet: characterSet, mode: .containsOnly)

        var testValue = "lowercase"
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "camelCase!"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.characterSetError])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testDoesNotContain() {

        let characterSet = CharacterSet.symbols
        let rule = CharacterSetRule(characterSet: characterSet, mode: .doesNotContain)

        var testValue = "A String With No Symbols."
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "Is $ a symbol?"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.characterSetError])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testContainsNumber() {

        let rule = CharacterSetRule.containsNumber(minimum: 1, maximum: 3)

        var testValue = "Hey there.! 1 is good enough."
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "zero numbers are not enough"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.occurrencesNotInRange])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "Maximum of 3 numbers are allowed. So what to do with 999 other numbers."
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.occurrencesNotInRange])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.occurrencesNotInRange])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testContainsUpperCase() {

        let rule = CharacterSetRule.containsUpperCase(minimum: 1, maximum: 3)

        var testValue = "Hey there.! 1 upper case is good enough."
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "zero upper case are not enough"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.occurrencesNotInRange])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "Maximum Of 3 UpperCases Are Allowed."
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.occurrencesNotInRange])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.occurrencesNotInRange])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testContainsLowerCase() {

        let rule = CharacterSetRule.containsLowerCase(minimum: 1, maximum: 3)

        var testValue = "HEY THERE, 'a' IS THE ONLY LOWER CASE HERE."
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "0 LOWER CASES ARE NOT ENOUGH."
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.occurrencesNotInRange])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "Maximum Of 3 LowerCases Are Allowed."
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.occurrencesNotInRange])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.occurrencesNotInRange])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testContainsSymbols() {

        let rule = CharacterSetRule.containsSymbols(minimum: 1, maximum: 3)

        var testValue = "$ is the only symbol HERE"
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "0 SYMBOLS ARE NOT ENOUGH"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.occurrencesNotInRange])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "$Maximum Of ^3^ symbols are allowed$"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.occurrencesNotInRange])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.occurrencesNotInRange])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testNumbersOnly() {

        var rule = CharacterSetRule.numbersOnly()

        var testValue = "0555898666"
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "0000o0000"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidType])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        rule = CharacterSetRule.numbersOnly(ignoreCharactersIn: .whitespaces)
        testValue = "7623 2836 3 44 3435 "
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, "762328363443435")

        testValue = "    "
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertNotNil(result.errors)
        XCTAssertEqual(result.value as? String, "")
    }

    func testLowerCaseOnly() {

        var rule = CharacterSetRule.lowerCaseOnly()

        var testValue = "lowercase"
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "lowerCase"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidType])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        rule = CharacterSetRule.lowerCaseOnly(ignoreCharactersIn: CharacterSet.decimalDigits)
        testValue = "942dh88efbuwmd0efnwed5wjfw3fefhebf"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, "dhefbuwmdefnwedwjfwfefhebf")

        testValue = "0555"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertNotNil(result.errors)
        XCTAssertEqual(result.value as? String, "")
    }

    func testUpperCaseOnly() {

        var rule = CharacterSetRule.upperCaseOnly()

        var testValue = "UPPERCASE"
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "UpperCase"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidType])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        rule = CharacterSetRule.upperCaseOnly(ignoreCharactersIn: .whitespaces)
        testValue = " WEFW VERUVNE CWEMWOGBWE SDWKXMAEDNWEF EE "
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, "WEFWVERUVNECWEMWOGBWESDWKXMAEDNWEFEE")

        testValue = "    "
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertNotNil(result.errors)
        XCTAssertEqual(result.value as? String, "")
    }
}
