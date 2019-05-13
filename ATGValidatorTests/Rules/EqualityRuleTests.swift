//
//  EqualityRuleTests.swift
//  ATGValidatorTests
//
//  Created by Suraj Thomas K on 9/12/18.
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
