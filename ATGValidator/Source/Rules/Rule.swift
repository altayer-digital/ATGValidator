//
//  Rule.swift
//  ATGValidator
//
//  Created by Suraj Thomas K on 8/29/18.
//  Copyright © 2018 Al Tayer Group LLC. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Al Tayer Group LLC.
//  Any reproduction of this material must contain this notice.
//

// TODO: Add documentation

public protocol Rule {

    var error: Error { get set }

    func validate(value: Any) -> Result
}
