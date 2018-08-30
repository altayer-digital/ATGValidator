//
//  Validatable.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 8/30/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
//

// TODO: Add documentation
public protocol Validatable {

    var inputValue: Any { get }
    func satisfyAll(rules: [Rule]) -> Result
    func satisfyAny(rules: [Rule]) -> Result
}

extension Validatable {

    public var inputValue: Any {
        return self
    }

    public func satisfyAll(rules: [Rule]) -> Result {

        var result = Result.succeed(inputValue)

        rules.forEach({ result = result.and($0) })

        return result
    }

    public func satisfyAny(rules: [Rule]) -> Result {

        var result = Result.fail(inputValue)

        rules.forEach({ result = result.or($0) })

        return result
    }
}

extension String: Validatable {}
extension Bool: Validatable {}
extension Int: Validatable {}
extension Double: Validatable {}
extension Float: Validatable {}
extension Array: Validatable {}
extension Date: Validatable {}
