//
//  RuleTests.swift
//  ATGValidatorTests
//
//  Created by Serkut Yegin on 25.12.2018.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
//

import XCTest
@testable import ATGValidator

class RuleTests: XCTestCase {

    func testFailureResultWithCustomError() {

        let customErrorMessage = "custom error message"
        let emailRule = StringRegexRule.email.with(
            error: CustomValidationError(customErrorMessage)
        )
        let invalidEmailTestValue = "invalid email"
        let result = emailRule.validate(value: invalidEmailTestValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertNotNil(result.errors?.first)
        XCTAssertEqual(customErrorMessage, result.errors?.first?.localizedDescription)
    }

    func testFailureResultWithCustomErrorMessage() {

        let customErrorMessage = "custom error message"
        let emailRule = StringRegexRule.email.with(errorMessage: customErrorMessage)
        let invalidEmailTestValue = "invalid email"
        let result = emailRule.validate(value: invalidEmailTestValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertNotNil(result.errors?.first)
        XCTAssertEqual(customErrorMessage, result.errors?.first?.localizedDescription)
    }
}
