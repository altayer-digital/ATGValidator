//
//  RuleTests.swift
//  ATGValidatorTests
//
//  Created by Serkut Yegin on 25.12.2018.
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

class RuleTests: XCTestCase {

    func testFailureResultWithCustomError() {

        struct CustomError: Error, Equatable {

            let errorMessage: String
        }

        let customErrorMessage = "custom error message"
        let customError = CustomError(errorMessage: customErrorMessage)
        let emailRule = StringRegexRule.email.with(error: customError)
        let invalidEmailTestValue = "invalid email"
        let result = emailRule.validate(value: invalidEmailTestValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertNotNil(result.errors?.first)
        let error = result.errors?.first as? CustomError
        XCTAssertEqual(customError, error)
        XCTAssertEqual(customErrorMessage, error?.errorMessage)
    }

    func testFailureResultWithCustomErrorMessage() {

        let customErrorMessage = "custom error message"
        let emailRule = StringRegexRule.email.with(errorMessage: customErrorMessage)
        let invalidEmailTestValue = "invalid email"
        let result = emailRule.validate(value: invalidEmailTestValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertNotNil(result.errors?.first)
        let error = result.errors?.first as? ValidationError
        XCTAssertEqual(customErrorMessage, error?.customErrorMessage)
    }
}
