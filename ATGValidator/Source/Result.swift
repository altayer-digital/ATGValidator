//
//  Result.swift
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

public struct Result {

    public enum Status {

        case success
        case failure
    }

    public var status: Status
    public var errors: [Error]?
    public var value: Any

    internal static func fail(_ value: Any, withErrors errors: [Error]? = nil) -> Result {

        return Result(status: .failure, errors: errors, value: value)
    }

    internal static func succeed(_ value: Any) -> Result {

        return Result(status: .success, errors: nil, value: value)
    }
}

extension Result {

    internal func and(_ rule: Rule) -> Result {

        var result = self
        let newResult = rule.validate(value: result.value)

        switch result.status {
        case .success:
            return newResult
        case .failure:
            if let errors = newResult.errors {
                result.errors?.append(contentsOf: errors)
            }
            result.value = newResult.value
            return result
        }
    }

    internal func or(_ rule: Rule) -> Result {

        var result = self

        switch result.status {
        case .success:
            return result
        case .failure:
            let newResult = rule.validate(value: result.value)
            result.status = newResult.status
            result.value = newResult.value
            if let errors = newResult.errors {
                result.errors?.append(contentsOf: errors)
            }
            return result
        }
    }
}
