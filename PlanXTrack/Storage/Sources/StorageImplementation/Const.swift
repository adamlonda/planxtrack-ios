//
//  Const.swift
//  Storage
//
//  Created by Adam Londa on 01.01.2025.
//

extension String {
    static let brandName = "PlanXTrack"
}

extension CVarArg where Self == String {
    static var brandName: Self {
        .brandName
    }
}

extension Int {
    static let loadLimit = 21
}
