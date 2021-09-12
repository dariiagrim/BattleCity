//
//  Utils.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 12.09.2021.
//

import Foundation


enum Rotation {
    case up, down, left, right
}

func arrayToGameZonePosition(coordinate: Int) -> CGFloat {
    return CGFloat(coordinate) * 35 + 17.5
}


func gameZoneToArrayPosition(coordinate: CGFloat) -> Int {
    return Int(((coordinate - 17.5) / 35).rounded(.toNearestOrEven))
}
