//
//  FormValidatorTests.swift
//  ATGValidatorTests
//
//  Created by Suraj Thomas K on 9/11/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
//

import XCTest
@testable import ATGValidator

class FormValidatorTests: XCTestCase {

    private let form = FormValidator()
    private let textfield = UITextField()
    private let textView = UITextView()

    override func setUp() {

        super.setUp()

        textfield.validationRules = [StringLengthRule.min(8)]
        textView.validationRules = [StringLengthRule.max(10)]

        form.add(textfield)
        form.add(textView)
    }

    func testFormFailure() {

        textfield.text = "Hello"
        textView.text = "Holas"

        form.handler = { (result) in

            XCTAssertEqual(result.status, .failure)
            XCTAssertEqual(result.errors as? [ValidationError], [ValidationError.shorterThanMinimumLength])
        }

        form.validateForm()
    }

    func testFormSuccess() {

        textfield.text = "HelloMisterPerera"
        textView.text = "Holas"

        form.handler = { (result) in

            XCTAssertEqual(result.status, .success)
            XCTAssertNil(result.errors)
        }

        form.validateForm()
    }
}
