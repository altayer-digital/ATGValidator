//
//  StringRegexRuleTests.swift
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

class StringRegexRuleTests: XCTestCase {

    func testInvalidType() {

        let testValue = 34
        let regex = "\\d"

        let rule = StringRegexRule(regex: regex)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidType])
        XCTAssertEqual(result.value as? Int, testValue)
    }

    func testSuccessCase() {

        let regex = "\\+\\d{2,3}-\\d{9,10}"

        var testValue = "+971-555898666"
        let rule = StringRegexRule(regex: regex)
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "+91-7885433992"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testFailureCase() {

        let regex = "\\+\\d{2,3}-\\d{9,10}"

        var testValue = "+971555898666"
        let rule = StringRegexRule(regex: regex)
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.regexMismatch])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "91-7885433992"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.regexMismatch])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "+1-7885433992"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.regexMismatch])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "+9331-7885433992"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.regexMismatch])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "+971-33992"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.regexMismatch])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.regexMismatch])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testEmail() {

        let rule = StringRegexRule.email

        var testValue = "suthomas@altayer.com"
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "@altayer.com"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidEmail])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "suthomas@.com"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidEmail])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "suthomas@altayer.c"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidEmail])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "suthomas.altayer@com"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidEmail])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidEmail])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testContainsNumber() {

        let rule = StringRegexRule.containsNumber(min: 2, max: 4)

        var testValue = "buy 1 get 2 free"
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "no numbers here"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.numberNotFound])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "5 numbers here including 1, 2, 3 and 4."
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.numberNotFound])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.numberNotFound])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testContainsLowerCase() {

        let rule = StringRegexRule.containsLowerCase(min: 5, max: 10)

        var testValue = "HeLlO GeNeRaL KeNoBi!"
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "NO LOWERCASE HERE"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.lowerCaseNotFound])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "'d' IS THE ONLY LOWERCASE HERE.!"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.lowerCaseNotFound])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.lowerCaseNotFound])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testContainsUpperCase() {

        let rule = StringRegexRule.containsUpperCase(min: 5, max: 10)

        var testValue = "HeLlO GeNeRaL KeNoBi!"
        var result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "no uppercase here"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.upperCaseNotFound])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = "'U' is the only upper case character here.!"
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.upperCaseNotFound])
        XCTAssertEqual(result.value as? String, testValue)

        testValue = ""
        result = rule.validate(value: testValue)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.upperCaseNotFound])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testNumbersOnly() {

        let rule = StringRegexRule.numbersOnly

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
    }

    func testLowerCaseOnly() {

        let rule = StringRegexRule.lowerCaseOnly

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
    }

    func testUpperCaseOnly() {

        let rule = StringRegexRule.upperCaseOnly

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
    }
}
