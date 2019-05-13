//
//  RangeRuleTests.swift
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
