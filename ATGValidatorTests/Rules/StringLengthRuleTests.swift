//
//  StringLengthRuleTests.swift
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

class StringLengthRuleTests: XCTestCase {

    func testInvalidType() {

        let testValue = 34
        let min = 5
        let max = 15

        let rule = StringLengthRule(min: min, max: max, trimWhiteSpace: true, ignoreCharactersIn: nil)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidType])
        XCTAssertEqual(result.value as? Int, testValue)
    }

    func testLengthEqual() {

        let testSuccessValue = "1234567"
        let length = 7

        let rule = StringLengthRule.equal(to: length)
        let result = rule.validate(value: testSuccessValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testSuccessValue)

        let testFailureValue = "123"
        let resultFailute = rule.validate(value: testFailureValue)

        XCTAssertEqual(resultFailute.status, .failure)
        XCTAssertEqual(resultFailute.errors as? [ValidationError], [ValidationError.notEqual])
        XCTAssertEqual(resultFailute.value as? String, testFailureValue)
    }

    func testLengthInRange() {

        let testValue = "1234567"
        let min = 5
        let max = 15

        let rule = StringLengthRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testOnLowerBound() {

        let testValue = "1234567"
        let min = 7
        let max = 15

        let rule = StringLengthRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testOnUpperBound() {

        let testValue = "1234567"
        let min = 2
        let max = 7

        let rule = StringLengthRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testAboveUpperBound() {

        let testValue = "1234567"
        let max = 5

        let rule = StringLengthRule.max(max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.longerThanMaximumLength])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testBelowLowerBound() {

        let testValue = "1234567"
        let min = 10

        let rule = StringLengthRule.min(min)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.shorterThanMinimumLength])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testWithTrimmingWhiteSpace() {

        let testValue = "1234567   "
        let min = 2
        let max = 7

        let rule = StringLengthRule(min: min, max: max)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testTrimmingWithWhiteSpaceInBetween() {

        let testValue = "   123 4567   "
        let length = 8

        let rule = StringLengthRule.equal(to: length)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testWithoutTrimmingWhiteSpace() {

        let testValue = "1234567   "
        let min = 2
        let max = 7

        let rule = StringLengthRule(min: min, max: max, trimWhiteSpace: false)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.lengthOutOfRange])
        XCTAssertEqual(result.value as? String, testValue)
    }

    func testIgnoreCharacterSet() {

        let testValue = "1234$de $     ^"
        let length = 6

        let rule = StringLengthRule.equal(to: length, ignoreCharactersIn: .symbols)
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, testValue)
    }
}
