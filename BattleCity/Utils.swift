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


func rotationToAngle(rotation: Rotation) -> CGFloat{
    let angle: CGFloat
    switch rotation {
    case .up:
        angle = 0
    case .down:
        angle = .pi
    case .left:
        angle = .pi / 2
    case .right:
        angle = .pi * 3 / 2
    }
    return angle
}


func checkIfLevelIsValid(level1Copy: [[Int]]) -> Bool {
    var counter = 0
    for row in level1 {
        for element in row {
            if element == 2 {
                counter += 1
            }
        }
    }
    
    return counter == 1
}
