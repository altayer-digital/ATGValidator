//
//  EqualityRuleTests.swift
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

class EqualityRuleTests: XCTestCase {

    func testInvalidType() {

        let ruleValue = "Checking for Equality"
        let testValue = 344.56

        let rule = EqualityRule(value: ruleValue)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidType])
        XCTAssertEqual(result.value as? Double, testValue)
    }

    func testStringEqual() {

        let testValue1 = "Checking for Equality"
        let testValue2 = "Checking for Equality"

        let rule = EqualityRule(value: testValue1)
        let result = rule.validate(value: testValue2)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue2)
    }

    func testStringUnequal() {

        let testValue1 = "Checking for Equality"
        let testValue2 = "Different text"

        let rule = EqualityRule(value: testValue1)
        let result = rule.validate(value: testValue2)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.notEqual])
        XCTAssertEqual(result.value as? String, testValue2)
    }

    func testIntEqual() {

        let testValue1 = 34
        let testValue2 = 34

        let rule = EqualityRule(value: testValue1)
        let result = rule.validate(value: testValue2)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? Int, testValue2)
    }

    func testIntUnequal() {

        let testValue1 = 34
        let testValue2 = 664

        let rule = EqualityRule(value: testValue1)
        let result = rule.validate(value: testValue2)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.notEqual])
        XCTAssertEqual(result.value as? Int, testValue2)
    }

    func testDoubleEqual() {

        let testValue1 = 34.44
        let testValue2 = 34.44

        let rule = EqualityRule(value: testValue1)
        let result = rule.validate(value: testValue2)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? Double, testValue2)
    }

    func testDoubleUnequal() {

        let testValue1 = 22.34
        let testValue2 = 84.44

        let rule = EqualityRule(value: testValue1)
        let result = rule.validate(value: testValue2)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.notEqual])
        XCTAssertEqual(result.value as? Double, testValue2)
    }

    func testArrayEqual() {

        let testValue1 = ["one", "two", "three"]
        let testValue2 = ["one", "two", "three"]

        let rule = EqualityRule(value: testValue1)
        let result = rule.validate(value: testValue2)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? [String], testValue2)
    }

    func testArrayUnequal() {

        let testValue1 = ["one", "two", "three"]
        let testValue2 = ["four", "two", "three"]

        let rule = EqualityRule(value: testValue1)
        let result = rule.validate(value: testValue2)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.notEqual])
        XCTAssertEqual(result.value as? [String], testValue2)
    }
}
