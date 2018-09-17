//
//  StringValueMatchRuleTests.swift
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

class StringValueMatchRuleTests: XCTestCase {

    private let textfield1 = UITextField()
    private let textfield2 = UITextField()

    func testSuccess() {

        textfield1.text = "Hello"
        textfield2.text = "Hello"

        let rule = StringValueMatchRule(base: textfield1)
        var result = textfield2.satisfyAll(rules: [rule])

        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, textfield2.text)

        textfield1.text = ""
        textfield2.text = ""
        result = textfield2.satisfyAll(rules: [rule])
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, textfield2.text)

        textfield1.text = "gtth \n nn $$762  dbhebc\t\t"
        textfield2.text = "gtth \n nn $$762  dbhebc\t\t"
        result = textfield2.satisfyAll(rules: [rule])
        XCTAssertEqual(result.status, .success)
        XCTAssertNil(result.errors)
        XCTAssertEqual(result.value as? String, textfield2.text)
    }

    func testFailure() {

        textfield1.text = "Hello"
        textfield2.text = "Hola"

        let rule = StringValueMatchRule(base: textfield1)
        var result = textfield2.satisfyAll(rules: [rule])

        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.notEqual])
        XCTAssertEqual(result.value as? String, textfield2.text)

        textfield2.text = ""
        result = textfield2.satisfyAll(rules: [rule])
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.notEqual])
        XCTAssertEqual(result.value as? String, textfield2.text)

        textfield1.text = ""
        textfield2.text = "Adios"
        result = textfield2.satisfyAll(rules: [rule])
        XCTAssertEqual(result.status, .failure)
        XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.notEqual])
        XCTAssertEqual(result.value as? String, textfield2.text)
    }
}
