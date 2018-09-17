//
//  PaymentCardTypeTests.swift
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

class PaymentCartTypeTests: XCTestCase {

    let visaElectronCodes = [
        "417500",
        "4026",
        "4405",
        "4508",
        "4844",
        "4913",
        "4917"
    ]

    func testMinimumLengthForSuggestion() {

        var cardNumber = "375"
        var suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
        XCTAssertNil(suggestedType)

        cardNumber = "3754"
        suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
        XCTAssertNotNil(suggestedType)
    }

    func testSuggestionFailure() {

        let cardNumber = "123456789012"
        let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
        XCTAssertNil(suggestedType)
    }

    func testAmexSuggestions() {

        for i in 3399...3500 {
            let cardNumber = String(i)
            let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
            XCTAssertEqual(suggestedType, 3400..<3500 ~= i ? .amex : nil)
        }
        for i in 3699...3800 {
            let cardNumber = String(i)
            let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
            XCTAssertEqual(suggestedType, 3700..<3800 ~= i ? .amex : .dinersClub)
        }
    }

    func testMasterCardSuggestions() {

        for i in 5099...5600 {
            let cardNumber = String(i)
            let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
            XCTAssertEqual(suggestedType, 5100..<5600 ~= i ? .mastercard : nil)
        }
        for i in 2220...2721 {
            let cardNumber = String(i)
            let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
            XCTAssertEqual(suggestedType, 2221...2720 ~= i ? .mastercard : nil)
        }
    }

    func testMaestroSuggestions() {

        let validCodes = [
            "5018",
            "5020",
            "5038",
            "6304",
            "6703",
            "6708",
            "6759",
            "6761",
            "6762",
            "6763"
        ]

        var codes = [
            "5017",
            "5019",
            "5021",
            "5037",
            "5039",
            "6303",
            "6305",
            "6702",
            "6704",
            "6707",
            "6709",
            "6758",
            "6760",
            "6761",
            "6762",
            "6763",
            "6764"
        ]

        codes.append(contentsOf: validCodes)
        for cardNumber in codes {
            let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
            XCTAssertEqual(suggestedType, validCodes.contains(cardNumber) ? .maestro : nil)
        }
    }

    func testVisaElectronSuggestions() {

        var codes = [
            "417499",
            "417501",
            "4025",
            "4027",
            "4404",
            "4406",
            "4507",
            "4509",
            "4843",
            "4845",
            "4912",
            "4914",
            "4916",
            "4918"
        ]

        codes.append(contentsOf: visaElectronCodes)

        for cardNumber in codes {
            let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
            XCTAssertEqual(
                suggestedType,
                visaElectronCodes.contains(cardNumber) ? .visaElectron : .visa
            )
        }
    }

    func testVisaSuggestions() {

        for i in 3999...5000 where !visaElectronCodes.contains(String(i)) {

            let cardNumber = String(i)
            let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
            XCTAssertEqual(suggestedType, 4000..<5000 ~= i ? .visa : nil)
        }
    }

    func testDiscoverSuggestions() {

        for i in 6439...6600 {

            let cardNumber = String(i)
            let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
            XCTAssertEqual(suggestedType, 6440..<6600 ~= i ? .discover : nil)
        }

        for i in 6219...6230 {

            let cardNumber = String(i)
            let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
            XCTAssertEqual(suggestedType, 6220..<6230 ~= i ? .discover : nil)
        }

        for i in 6010...6012 {

            let cardNumber = String(i)
            let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
            XCTAssertEqual(suggestedType, i == 6011 ? .discover : nil)
        }
    }

    func testDinersClubSuggestions() {

        for i in 2999...3060 {

            let cardNumber = String(i)
            let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
            XCTAssertEqual(suggestedType, 3000..<3060 ~= i ? .dinersClub : nil)
        }

        for i in 3599...3700 {

            let cardNumber = String(i)
            let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
            XCTAssertEqual(
                suggestedType,
                3600..<3700 ~= i ? .dinersClub : (i == 3700 ? .amex : nil)
            )
        }

        for i in 3799...3900 {

            let cardNumber = String(i)
            let suggestedType = PaymentCardType.suggestedTypeForCardNumber(cardNumber)
            XCTAssertEqual(
                suggestedType,
                3800..<3900 ~= i ? .dinersClub : (i == 3799 ? .amex : nil)
            )
        }
    }
}

extension PaymentCartTypeTests {

    func testEmptyCardNumber() {

        let cardNumber = ""
        let type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)
    }

    func testAmexCardType() {

        var cardNumber = "378282246310005"
        var type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .amex)

        cardNumber = "371449635398431"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .amex)

        cardNumber = "378734493671000"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .amex)

        cardNumber = "378282246310"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)

        cardNumber = "378282246310005378"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)
    }

    func testMasterCardType() {

        var cardNumber = "5555555555554444"
        var type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .mastercard)

        cardNumber = "5105105105105100"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .mastercard)

        cardNumber = "5105105105105100510"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)

        cardNumber = "5105105105"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)
    }

    func testMaestroType() {

        var cardNumber = "6759649826438453"
        var type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .maestro)

        cardNumber = "67596498264384"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)

        cardNumber = "675964982643845374"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)
    }

    func testVisaElectronType() {

        var cardNumber = "4917300800000000"
        var type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .visaElectron)

        cardNumber = "4917300800000"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .visaElectron)

        cardNumber = "491730080000"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)

        cardNumber = "49173008000033"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)

        cardNumber = "4917300800000000000"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)
    }

    func testVisaCardType() {

        var cardNumber = "4444333322221111"
        var type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .visa)

        cardNumber = "4911830000000"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .visa)

        cardNumber = "491183000000"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)

        cardNumber = "491183000000000"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)

        cardNumber = "49118300000000000"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)
    }

    func testDiscoverType() {

        var cardNumber = "6011000400000000"
        var type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .discover)

        cardNumber = "6011000400000000000"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .discover)

        cardNumber = "6011000400000"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)

        cardNumber = "601100040000000000"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)

        cardNumber = "60110004000000000000"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)
    }

    func testDinersClubType() {

        var cardNumber = "36700102000000"
        var type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .dinersClub)

        cardNumber = "36148900647913"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertEqual(type, .dinersClub)

        cardNumber = "361489006479"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)

        cardNumber = "3614890064791300"
        type = PaymentCardType(cardNumber: cardNumber)
        XCTAssertNil(type)
    }
}
