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