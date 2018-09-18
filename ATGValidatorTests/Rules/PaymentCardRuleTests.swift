//
//  PaymentCardRuleTests.swift
//  ATGValidatorTests
//
//  Created by Suraj Thomas K on 9/17/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
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
