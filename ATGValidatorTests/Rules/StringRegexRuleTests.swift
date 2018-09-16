//
//  StringRegexRuleTests.swift
//  ATGValidatorTests
//
//  Created by Suraj Thomas K on 9/16/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
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
