//
//  Constants.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 04.09.2021.
//

import Foundation

struct Constants {
    static let upArrow: UInt16 = 0x7E
    static let downArrow: UInt16 = 0x7D
    static let rightArrow: UInt16 = 0x7C
    static let leftArrow: UInt16 = 0x7B
    static let space: UInt16 = 0x31
    static let p: UInt16 = 0x23
    static let o: UInt16 = 0x1F
    static let e: UInt16 = 0x0E
    static let playerFlag: UInt32 = 1 << 0
    static let bulletFlag: UInt32 = 1 << 1
    static let wallFlag: UInt32 = 1 << 2
    static let enemyFlag: UInt32 = 1 << 3
    static let baseFlag: UInt32 = 1 << 4
}

