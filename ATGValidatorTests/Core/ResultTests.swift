//
//  ResultTests.swift
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

class ResultTests: XCTestCase {

    func testResultSuccessValues() {

        let stringValue = "Hello"
        let stringResult = Result.succeed(stringValue)
        XCTAssertEqual((stringResult.value as? String), stringValue)

        let intValue = 45
        let intResult = Result.succeed(intValue)
        XCTAssertEqual((intResult.value as? Int), intValue)

        let floatValue: Float = 75.0
        let floatResult = Result.succeed(floatValue)
        XCTAssertEqual((floatResult.value as? Float), floatValue)
    }

    func testResultFailureValues() {

        let stringValue = "Hello"
        let stringResult = Result.fail(stringValue)
        XCTAssertEqual((stringResult.value as? String), stringValue)

        let intValue = 45
        let intResult = Result.fail(intValue)
        XCTAssertEqual((intResult.value as? Int), intValue)

        let floatValue: Float = 75.0
        let floatResult = Result.fail(floatValue)
        XCTAssertEqual((floatResult.value as? Float), floatValue)
    }

    func testResultErrors() {

        let testValue: [ValidationError] = [.invalidType, .notEqual]
        let result = Result.fail(testValue, withErrors: testValue)
        XCTAssertEqual(result.errors?.count, testValue.count)

        let successResult = Result.succeed(testValue)
        XCTAssertNil(successResult.errors)
    }

    func testResultOrOperation() {

        // success or success = success
        let result1 = Result.succeed("1")
        let rule1 = EqualityRule(value: "1")
        let or1 = result1.or(rule1)
        XCTAssertEqual(or1.status, .success)
        XCTAssertEqual((or1.value as? String), "1")
        XCTAssertNil(or1.errors)

        // success or failure = success
        let result2 = Result.succeed("1")
        let rule2 = EqualityRule(value: "5")
        let or2 = result2.or(rule2)
        XCTAssertEqual(or2.status, .success)
        XCTAssertEqual((or2.value as? String), "1")
        XCTAssertNil(or2.errors)

        // failure or success = success
        let result3 = Result.fail("1", withErrors: [ValidationError.invalidEmail])
        let rule3 = EqualityRule(value: "1")
        let or3 = result3.or(rule3)
        XCTAssertEqual(or3.status, .success)
        XCTAssertEqual((or3.value as? String), "1")
        XCTAssertNotNil(or3.errors)

        // failure or failure = failure
        let result4 = Result.fail("1", withErrors: [ValidationError.invalidEmail])
        let rule4 = EqualityRule(value: "3")
        let or4 = result4.or(rule4)
        XCTAssertEqual(or4.status, .failure)
        XCTAssertEqual((or4.value as? String), "1")
        XCTAssertNotNil(or4.errors)
    }

    func testResultAndOperation() {

        // success and success = success
        let result1 = Result.succeed("1")
        let rule1 = EqualityRule(value: "1")
        let or1 = result1.and(rule1)
        XCTAssertEqual(or1.status, .success)
        XCTAssertEqual((or1.value as? String), "1")
        XCTAssertNil(or1.errors)

        // success and failure = failure
        let result2 = Result.succeed("1")
        let rule2 = EqualityRule(value: "5")
        let or2 = result2.and(rule2)
        XCTAssertEqual(or2.status, .failure)
        XCTAssertEqual((or2.value as? String), "1")
        XCTAssertNotNil(or2.errors)

        // failure and success = failure
        let result3 = Result.fail("1", withErrors: [ValidationError.invalidEmail])
        let rule3 = EqualityRule(value: "1")
        let or3 = result3.and(rule3)
        XCTAssertEqual(or3.status, .failure)
        XCTAssertEqual((or3.value as? String), "1")
        XCTAssertNotNil(or3.errors)

        // failure and failure = failure
        let result4 = Result.fail("1", withErrors: [ValidationError.invalidEmail])
        let rule4 = EqualityRule(value: "3")
        let or4 = result4.and(rule4)
        XCTAssertEqual(or4.status, .failure)
        XCTAssertEqual((or4.value as? String), "1")
        XCTAssertNotNil(or4.errors)
    }

    func testResultMergeOperation() {

        // success * success = success
        var result1 = Result.succeed("1")
        var result2 = Result.succeed("2")
        var merge = result1.merge(result2)
        XCTAssertEqual(merge.status, .success)
        XCTAssertEqual(merge.value as? String, result1.value as? String)
        XCTAssertNil(merge.errors)

        // success * failure = failure
        result2 = Result.fail("3", withErrors: [ValidationError.invalidEmail])
        merge = result1.merge(result2)
        XCTAssertEqual(merge.status, .failure)
        XCTAssertEqual((merge.value as? String), result1.value as? String)
        XCTAssertNotNil(merge.errors)

        // failure * success = failure
        merge = result2.merge(result1)
        XCTAssertEqual(merge.status, .failure)
        XCTAssertEqual((merge.value as? String), result2.value as? String)
        XCTAssertNotNil(merge.errors)

        result1 = Result.fail("4", withErrors: [ValidationError.invalidType])
        merge = result1.merge(result2)
        XCTAssertEqual(merge.status, .failure)
        XCTAssertEqual((merge.value as? String), result1.value as? String)
        XCTAssertNotNil(merge.errors)
    }
}
