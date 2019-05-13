//
//  ValidatableTests.swift
//  ATGValidatorTests
//
//  Created by Suraj Thomas K on 9/11/18.
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
