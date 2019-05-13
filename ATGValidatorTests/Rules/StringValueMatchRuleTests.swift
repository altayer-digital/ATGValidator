//
//  StringValueMatchRuleTests.swift
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
