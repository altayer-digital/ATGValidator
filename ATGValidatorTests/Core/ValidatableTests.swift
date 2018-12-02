//
//  ValidatableTests.swift
//  ATGValidatorTests
//
//  Created by Suraj Thomas K on 9/11/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
//

import XCTest
@testable import ATGValidator

class ValidatableTests: XCTestCase {

    func testStringSatisfyAll() {

        let testString = "This is a string of length 30."

        var rules: [Rule] = [
            StringLengthRule.min(10),
            StringLengthRule.max(50),
            StringRegexRule.containsNumber()
        ]

        let result = testString.satisfyAll(rules: rules)
        XCTAssertEqual(result.status, .success)
        XCTAssertEqual(result.value as? String, testString)
        XCTAssertNil(result.errors)

        rules.append(StringRegexRule.numbersOnly)
        let failedResult = testString.satisfyAll(rules: rules)
        XCTAssertEqual(failedResult.status, .failure)
        XCTAssertEqual(failedResult.value as? String, testString)
        XCTAssertEqual(failedResult.errors as? [ValidationError], [ValidationError.invalidType])
    }

    func testStringSatisfyAny() {

        let testString = "This is a string without any digits."

        var rules: [Rule] = [
            StringLengthRule.min(50),
            StringRegexRule.containsNumber(),
            CharacterSetRule.upperCaseOnly()
        ]
        let errors = rules.map({ $0.error }) as? [ValidationError]

        var result = testString.satisfyAny(rules: rules)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.value as? String, testString)
        XCTAssertEqual(result.errors as? [ValidationError], errors)

        rules.append(EqualityRule(value: testString))
        result = testString.satisfyAny(rules: rules)
        XCTAssertEqual(result.status, .success)
        XCTAssertEqual(result.value as? String, testString)
        XCTAssertNotNil(result.errors)
        XCTAssertEqual(result.errors as? [ValidationError], errors)
    }

    func testIntSatisfyAll() {

        let testValue = 10

        var rules: [Rule] = [
            EqualityRule(value: 10),
            RangeRule(min: 5, max: 15)
        ]

        var result = testValue.satisfyAll(rules: rules)
        XCTAssertEqual(result.status, .success)
        XCTAssertEqual(result.value as? Int, testValue)
        XCTAssertNil(result.errors)

        rules.append(EqualityRule(value: 45))
        result = testValue.satisfyAll(rules: rules)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.value as? Int, testValue)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.notEqual])
    }

    func testIntSatisfyAny() {

        let testValue = 10

        var rules: [Rule] = [
            EqualityRule(value: 12),
            RangeRule(min: 15, max: 30)
        ]
        let errors = rules.map({ $0.error }) as? [ValidationError]

        var result = testValue.satisfyAny(rules: rules)
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.value as? Int, testValue)
        XCTAssertEqual(result.errors as? [ValidationError], errors)

        rules.append(EqualityRule(value: 10))
        result = testValue.satisfyAny(rules: rules)
        XCTAssertEqual(result.status, .success)
        XCTAssertEqual(result.value as? Int, testValue)
        XCTAssertEqual(result.errors as? [ValidationError], errors)
    }
}
