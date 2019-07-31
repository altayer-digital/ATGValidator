//
//  PaymentCardRuleTests.swift
//  ATGValidatorTests
//
//  Created by Suraj Thomas K on 9/17/18.
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

class PaymentCardRuleTests: XCTestCase {

    func testInvalidType() {

        let testValue = 34

        let rule = PaymentCardRule()
        let result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.invalidType])
        XCTAssertEqual(result.value as? Int, testValue)
    }

    func testCustomErrors() {

        struct CustomError: Error, Equatable {

            let errorMessage: String
        }

        let customErrorMessage1 = "custom error message 1"
        let customError1 = CustomError(errorMessage: customErrorMessage1)
        let customErrorMessage2 = "custom error message 2"
        let customError2 = CustomError(errorMessage: customErrorMessage2)

        let rule = PaymentCardRule(
            acceptedTypes: [.amex],
            invalidCardNumberError: customError1,
            cardTypeNotSupportedError: customError2
        )

        var testValue = "37828224631"
        var result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertNotNil(result.errors?.first)
        var error = result.errors?.first as? CustomError
        XCTAssertEqual(customError1, error)
        XCTAssertEqual(customErrorMessage1, error?.errorMessage)

        testValue = "5555555555554444"
        result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertNotNil(result.errors?.first)
        error = result.errors?.first as? CustomError
        XCTAssertEqual(customError2, error)
        XCTAssertEqual(customErrorMessage2, error?.errorMessage)
    }

    func testFailure() {

        let rule = PaymentCardRule(acceptedTypes: [.amex])

        // amex
        var testValue = "37828224631"
        var result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(
            result.errors as? [ValidationError],
            [ValidationError.invalidPaymentCardNumber]
        )
        XCTAssertEqual(result.value as? PaymentCardType, .amex)

        testValue = "378"
        result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(
            result.errors as? [ValidationError],
            [ValidationError.invalidPaymentCardNumber]
        )
        XCTAssertEqual(result.value as? PaymentCardType, nil)

        // mastercard
        testValue = "5555555555554444"
        result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(
            result.errors as? [ValidationError],
            [ValidationError.paymentCardNotSupported]
        )
        XCTAssertEqual(result.value as? PaymentCardType, .mastercard)
    }

    func testAllCardsInitializer() {

        let rule = PaymentCardRule()

        // amex
        var testValue = "378282246310005"
        var result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? PaymentCardType, .amex)

        // mastercard
        testValue = "5555555555554444"
        result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? PaymentCardType, .mastercard)

        // maestro
        testValue = "6759649826438453"
        result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? PaymentCardType, .maestro)

        // visa electron
        testValue = "4917300800000000"
        result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? PaymentCardType, .visaElectron)

        // visa
        testValue = "4444333322221111"
        result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? PaymentCardType, .visa)

        // discover
        testValue = "6011000400000000"
        result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? PaymentCardType, .discover)

        // diners club
        testValue = "36700102000000"
        result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? PaymentCardType, .dinersClub)
    }

    func testLimitedCardsInitializer() {

        let rule = PaymentCardRule(acceptedTypes: [.amex, .mastercard, .visa])

        // amex
        var testValue = "378282246310005"
        var result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? PaymentCardType, .amex)

        // mastercard
        testValue = "5555555555554444"
        result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? PaymentCardType, .mastercard)

        // maestro
        testValue = "6759649826438453"
        result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.paymentCardNotSupported])
        XCTAssertEqual(result.value as? PaymentCardType, .maestro)

        // visa electron
        testValue = "4917300800000000"
        result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.paymentCardNotSupported])
        XCTAssertEqual(result.value as? PaymentCardType, .visaElectron)

        // visa
        testValue = "4444333322221111"
        result = rule.validate(value: testValue)

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? PaymentCardType, .visa)
    }
}
