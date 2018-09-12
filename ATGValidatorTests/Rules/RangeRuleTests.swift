//
//  RangeRuleTests.swift
//  ATGValidatorTests
//
//  Created by Suraj Thomas K on 9/12/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
//

import XCTest
@testable import ATGValidator

class RangeRuleTests: XCTestCase {

    func testInvalidType() {

        let testValue = "Hello"
        let min = 5
        let max = 15

        let rule = RangeRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidType])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testIntSuccess() {

        let testValue = 13
        let min = 5
        let max = 15

        let rule = RangeRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? Int, testValue)
    }

    func testIntLowerThanLimitFail() {

        let testValue = 2
        let min = 5
        let max = 15

        let rule = RangeRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.valueOutOfRange])
        XCTAssertEqual(result.value as? Int, testValue)
    }

    func testIntHigherThanLimitFail() {

        let testValue = 20
        let min = 5
        let max = 15

        let rule = RangeRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.valueOutOfRange])
        XCTAssertEqual(result.value as? Int, testValue)
    }

    func testIntOnLowerLimit() {

        let testValue = 5
        let min = 5
        let max = 15

        let rule = RangeRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? Int, testValue)
    }

    func testIntOnUpperLimit() {

        let testValue = 15
        let min = 5
        let max = 15

        let rule = RangeRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? Int, testValue)
    }
}

extension RangeRuleTests {

    func testDoubleSuccess() {

        let testValue = 13.0
        let min = 5.0
        let max = 15.0

        let rule = RangeRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? Double, testValue)
    }

    func testDoubleLowerThanLimitFail() {

        let testValue = 2.0
        let min = 5.0
        let max = 15.0

        let rule = RangeRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.valueOutOfRange])
        XCTAssertEqual(result.value as? Double, testValue)
    }

    func testDoubleHigherThanLimitFail() {

        let testValue = 20.0
        let min = 5.0
        let max = 15.0

        let rule = RangeRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.valueOutOfRange])
        XCTAssertEqual(result.value as? Double, testValue)
    }

    func testDoubleOnLowerLimit() {

        let testValue = 5.0
        let min = 5.0
        let max = 15.0

        let rule = RangeRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? Double, testValue)
    }

    func testDoubleOnUpperLimit() {

        let testValue = 15.0
        let min = 5.0
        let max = 15.0

        let rule = RangeRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? Double, testValue)
    }
}
