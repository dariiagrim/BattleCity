//
//  Algs.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 14.09.2021.
//

import Foundation
import SpriteKit

class Point {
    let x: Int
    let y: Int
    let from: Point?
    let direction: Rotation
    
    init(x: Int, y: Int, from: Point?, direction: Rotation) {
        self.x = x
        self.y = y
        self.from = from
        self.direction = direction
    }
}

class PointWithPriority {
    let x: Int
    let y: Int
    let from: PointWithPriority?
    let distance: Int
    
    init(x: Int, y: Int, from: PointWithPriority?, distance: Int) {
        self.x = x
        self.y = y
        self.from = from
        self.distance = distance
    }
}

class AStarPoint {
    let x: Int
    let y: Int
    let from: AStarPoint?
    let g: Int
    let h: Int
    var f: Int {
        return g + h
    }
    let direction: Rotation
    
    init(x: Int, y: Int, from: AStarPoint?, endX: Int, endY: Int, direction: Rotation) {
        self.x = x
        self.y = y
        self.from = from
        var countedG = 0
        if let fromG = from?.g {
            countedG = fromG + 1
        }
        self.g = countedG
        self.h = abs(self.x - endX) + abs(self.y - endY)
        self.direction = direction
    }
}


func AStar(start: AStarPoint, end: AStarPoint?) -> [AStarPoint]{
    if let end = end {
        var openList = [AStarPoint]()
        var closedList = [AStarPoint]()
        var visitControlArray = Array(repeating: Array(repeating: 0, count: 24), count: 20)
        openList.append(start)
        var path = [AStarPoint]()
        while !openList.isEmpty{
            openList = openList.sorted(by: { (point1, point2) -> Bool in
                point1.f > point2.f
            })
            let v = openList.removeLast()
            let (possibleOptions, finish) = possibleToGoOptionsFromPosition(x: v.x, y: v.y, finishValue: 33)
            if finish {
                var finishX = v.x
                var finishY = v.y
                switch possibleOptions[0] {
                case .up:
                    finishY += 1
                case .down:
                    finishY -= 1
                case .right:
                    finishX += 1
                case .left:
                    finishX -= 1
                }
                let finishPoint = AStarPoint(x: finishX, y: finishY, from: v, endX: end.x, endY: end.y, direction: .up)
                path.append(finishPoint)
                var parent = finishPoint.from
                while parent != nil {
                    path.append(parent!)
                    parent = parent!.from
                }
                break
            }
            var successors = [AStarPoint]()
            
            if possibleOptions.contains(.up) {
                successors.append(AStarPoint(x: v.x, y: v.y + 1, from: v, endX: end.x, endY: end.y, direction: .up))
            }
            if possibleOptions.contains(.right) {
                successors.append(AStarPoint(x: v.x + 1, y: v.y, from: v, endX: end.x, endY: end.y, direction: .right))
            }
            if possibleOptions.contains(.left) {
                successors.append(AStarPoint(x: v.x - 1, y: v.y, from: v, endX: end.x, endY: end.y, direction: .left))
            }
            if possibleOptions.contains(.down) {
                successors.append(AStarPoint(x: v.x, y: v.y - 1, from: v, endX: end.x, endY: end.y, direction: .down))
            }
            
            for successor in successors {
                var doContinue = false
                for i in 0..<openList.count {
                    let openNode = openList[i]
                    if openNode.x == successor.x && openNode.y == successor.y {
                        if openNode.f > successor.f {
                            openList[i] = successor
                        }
                        doContinue = true
                        break
                    }
                }
                if doContinue {
                    continue
                }
                if visitControlArray[successor.y][successor.x] == 1 {
                    continue
                }
                openList.append(successor)
            }
            closedList.append(v)
            visitControlArray[v.y][v.x] = 1
        }
        
        return path
    } else {
        return [AStarPoint]()
    }
    
}

func BFS(startX: Int, startY: Int) -> [Point]{
    var visitControlArray = Array(repeating: Array(repeating: 0, count: 24), count: 20)
    var stack = [Point]()
    let level1Copy = level1
    stack.append(Point(x: startX, y: startY, from: nil, direction: .up))
    var finishPoint: Point? = nil
    
    if !checkIfLevelIsValid(level1Copy: level1Copy) {
        let (possibleOptions, finish) = possibleToGoOptionsFromPositionWithLevelCopy(x: startX, y: startY, finishValue: 2, levelCopy: level1Copy)
        
        var correctPath = [Point]()
        if possibleOptions.contains(.up) {
            correctPath.append(Point(x: startX, y: startY + 1, from: stack[0], direction: .up))
            return correctPath
        }
        if possibleOptions.contains(.right) {
            correctPath.append(Point(x: startX + 1, y: startY, from: stack[0], direction: .right))
            return correctPath
        }
        if possibleOptions.contains(.left) {
            correctPath.append(Point(x: startX - 1, y: startY, from: stack[0], direction: .left))
            return correctPath
        }
        if possibleOptions.contains(.down) {
            correctPath.append(Point(x: startX, y: startY - 1, from: stack[0], direction: .down))
            return correctPath
        }
    }
 
    
    while !stack.isEmpty {
        let v = stack.removeFirst()
        if visitControlArray[v.y][v.x] == 0 {
            visitControlArray[v.y][v.x] = 1
            let (possibleOptions, finish) = possibleToGoOptionsFromPositionWithLevelCopy(x: v.x, y: v.y, finishValue: 2, levelCopy: level1Copy)
            
            if possibleOptions.contains(.up) {
                stack.append(Point(x: v.x, y: v.y + 1, from: v, direction: .up))
            }
            if possibleOptions.contains(.right) {
                stack.append(Point(x: v.x + 1, y: v.y, from: v, direction: .right))
            }
            if possibleOptions.contains(.left) {
                stack.append(Point(x: v.x - 1, y: v.y, from: v, direction: .left))
            }
            if possibleOptions.contains(.down) {
                stack.append(Point(x: v.x, y: v.y - 1, from: v, direction: .down))
            }
            if finish {
                finishPoint = stack.removeLast()
                break
            }
        }
    }
    
    var path = [Point]()
    if let finishPoint = finishPoint {
        var point = finishPoint
        while point.from != nil {
            point = point.from!
            path.append(point)
        }
        _ = path.popLast()
    }
    var shortPath = [Point]()
    var counter = 0
    for node in path.reversed() {
        shortPath.append(node)
        counter += 1
        if counter > 10 {
            break
        }
    }
    return shortPath
}

//func BFS(startX: Int, startY: Int, gameZone: GameZone) {
//    var visitControlArray = Array(repeating: Array(repeating: 0, count: 24), count: 20)
//    var stack = [Point]()
//
//    stack.append(Point(x: startX, y: startY, from: nil))
//    var finishPoint: Point? = nil
//
//    while !stack.isEmpty {
//        let v = stack.removeFirst()
//        if visitControlArray[level1.count - v.y - 1][v.x] == 0 {
//            visitControlArray[level1.count - v.y - 1][v.x] = 1
//            let (possibleOptions, finish) = possibleToGoOptionsFromPosition(x: v.x, y: v.y, finishValue: 2)
//
//            if possibleOptions.contains(.up) {
//                stack.append(Point(x: v.x, y: v.y + 1, from: v))
//            }
//            if possibleOptions.contains(.right) {
//                stack.append(Point(x: v.x + 1, y: v.y, from: v))
//            }
//            if possibleOptions.contains(.left) {
//                stack.append(Point(x: v.x - 1, y: v.y, from: v))
//            }
//            if possibleOptions.contains(.down) {
//                stack.append(Point(x: v.x, y: v.y - 1, from: v))
//            }
//            if finish {
//                finishPoint = stack.removeLast()
//                break
//            }
//        }
//    }
//
//
//    var pathCounter = 0
//
//    if finishPoint != nil {
//        var point = finishPoint
//        while point != nil {
//            let pathMarker = SKShapeNode(rectOf: CGSize(width: 12, height: 12))
//            pathMarker.position = CGPoint(x: arrayToGameZonePosition(coordinate: point!.x), y: arrayToGameZonePosition(coordinate: point!.y))
//            pathMarker.fillColor = .blue
//            pathMarker.name = "pathMarker"
//            gameZone.addChild(pathMarker)
//            point = point!.from
//            pathCounter += 1
//        }
//    }
//
//    print(pathCounter)
//
//}
//
//
//
//func UCS(startX: Int, startY: Int, gameZone: GameZone) {
//    var visitControlArray = Array(repeating: Array(repeating: 0, count: 24), count: 20)
//    var stack = [PointWithPriority]()
//
//    var distanceCounter = 0
//    stack.append(PointWithPriority(x: startX, y: startY, from: nil, distance: distanceCounter))
//    var finishPoint: PointWithPriority? = nil
//
//    distanceCounter += 1
//
//    while !stack.isEmpty {
//        stack = stack.sorted(by: { (point1, point2) -> Bool in
//            point1.distance > point2.distance
//        })
//        let v = stack.removeLast()
//        if visitControlArray[level1.count - v.y - 1][v.x] == 0 {
//            visitControlArray[level1.count - v.y - 1][v.x] = 1
//            let (possibleOptions, finish) = possibleToGoOptionsFromPosition(x: v.x, y: v.y, finishValue: 2)
//
//            if possibleOptions.contains(.up) {
//                stack.append(PointWithPriority(x: v.x, y: v.y + 1, from: v, distance: distanceCounter))
//            }
//            if possibleOptions.contains(.right) {
//                stack.append(PointWithPriority(x: v.x + 1, y: v.y, from: v, distance: distanceCounter))
//            }
//            if possibleOptions.contains(.left) {
//                stack.append(PointWithPriority(x: v.x - 1, y: v.y, from: v,distance: distanceCounter))
//            }
//            if possibleOptions.contains(.down) {
//                stack.append(PointWithPriority(x: v.x, y: v.y - 1, from: v, distance: distanceCounter))
//            }
//            if finish {
//                finishPoint = stack.removeLast()
//                break
//            }
//            distanceCounter += 1
//        }
//    }
//
//
//
//    var pathCounter = 0
//    if finishPoint != nil {
//        var point = finishPoint
//        while point != nil {
//            let pathMarker = SKShapeNode(rectOf: CGSize(width: 8, height: 8))
//            pathMarker.position = CGPoint(x: arrayToGameZonePosition(coordinate: point!.x), y: arrayToGameZonePosition(coordinate: point!.y))
//            pathMarker.fillColor = .green
//            pathMarker.name = "pathMarker"
//            gameZone.addChild(pathMarker)
//            point = point!.from
//            pathCounter += 1
//        }
//    }
//    print(pathCounter)
//
//}


func possibleToGoOptionsFromPosition(x: Int, y: Int, finishValue: Int) -> ([Rotation], Bool) {
    var possibleOptions = [Rotation]()
    
   
    if x != 0 {
        let leftPositionValue = level1[y][x - 1]
        if  leftPositionValue == 0 || leftPositionValue == finishValue {
            if leftPositionValue == finishValue {
                return ([.left], true)
            }
            possibleOptions.append(.left)
        }
    }
    
    if x != level1[0].count - 1 {
        let rightPositionValue = level1[y][x + 1]
        if rightPositionValue == 0 || rightPositionValue == finishValue {
            if rightPositionValue == finishValue {
                return ([.right], true)
            }
            possibleOptions.append(.right)
        }
    }
    
    if y != 0 {
        let downPositionValue = level1[y - 1][x]
        if  downPositionValue == 0 || downPositionValue == finishValue {
            if downPositionValue == finishValue {
                return ([.down], true)
            }
            possibleOptions.append(.down)
        }
    }
    
    if y != level1.count - 1 {
        let upPositionValue = level1[y + 1][x]
        if upPositionValue == 0 || upPositionValue == finishValue {
            if upPositionValue == finishValue {
                return ([.up], true)
            }
            possibleOptions.append(.up)
        }
    }
    
    return (possibleOptions, false)
}

func possibleToGoOptionsFromPositionWithLevelCopy(x: Int, y: Int, finishValue: Int, levelCopy:[[Int]]) -> ([Rotation], Bool) {
    var possibleOptions = [Rotation]()
    
    if x != 0 {
        let leftPositionValue = levelCopy[y][x - 1]
        if  leftPositionValue == 0 || leftPositionValue == finishValue {
            if leftPositionValue == finishValue {
                return ([.left], true)
            }
            possibleOptions.append(.left)
        }
    }
    
    if x != level1[0].count - 1 {
        let rightPositionValue = levelCopy[y][x + 1]
        if rightPositionValue == 0 || rightPositionValue == finishValue {
            if rightPositionValue == finishValue {
                return ([.right], true)
            }
            possibleOptions.append(.right)
        }
    }
    
    if y != 0 {
        let downPositionValue = levelCopy[y - 1][x]
        if  downPositionValue == 0 || downPositionValue == finishValue {
            if downPositionValue == finishValue {
                return ([.down], true)
            }
            possibleOptions.append(.down)
        }
    }
    
    if y != level1.count - 1 {
        let upPositionValue = levelCopy[y + 1][x]
        if upPositionValue == 0 || upPositionValue == finishValue {
            if upPositionValue == finishValue {
                return ([.up], true)
            }
            possibleOptions.append(.up)
        }
    }
    
    return (possibleOptions, false)
}


enum AlgEnum  {
    case dfs, bfs, ucs
}

func possibleMovesNodes(node: Node) -> [Node] {
    var nodes = [Node]()
    let x = node.x
    let y = node.y
   
    if x != 0 {
        if  level1[y][x - 1] == 0 {
            nodes.append(Node(x: x - 1, y: y, direction: .left, isTerminal: false, value: 0))
        }
    }
    
    if x != level1[0].count - 1 {
        if  level1[y][x + 1] == 0 {
            nodes.append(Node(x: x + 1, y: y, direction: .right, isTerminal: false, value: 0))
        }
    }
    
    if y != 0 {
        if  level1[y - 1][x] == 0 {
            nodes.append(Node(x: x, y: y - 1, direction: .down, isTerminal: false, value: 0))
        }
    }
    
    if y != level1.count - 1 {
        if  level1[y + 1][x] == 0 {
            nodes.append(Node(x: x, y: y + 1, direction: .up, isTerminal: false, value: 0))
        }
    }
    return (nodes)
}



func minimaxWithAlphaBetaPruning(node: Node, depth: Int, alpha: Double, beta: Double, isMaxPlayer: Bool) -> Node {
    var alphaCopy = alpha
    var betaCopy = beta
    if depth == 0 || node.isTerminal {
        return Node(x: node.x, y: node.y, direction: node.direction, isTerminal: node.isTerminal, value: evaluatePosition(x: node.x, y: node.y, direction: node.direction))
    }
    if isMaxPlayer {
        var currentNode = Node(x: node.x, y: node.y, direction: node.direction, isTerminal: node.isTerminal, value: -1000)
        let children = possibleMovesNodes(node: node)
        for child in children {
            let childNode = minimaxWithAlphaBetaPruning(node: child, depth: depth - 1, alpha: alphaCopy, beta: betaCopy, isMaxPlayer: false)
            if childNode.value > currentNode.value {
                currentNode = childNode
            }
           
            if currentNode.value >= beta {
                break
            }
            alphaCopy = max(alphaCopy, currentNode.value)
        }
        return currentNode
    } else {
        var currentNode = Node(x: node.x, y: node.y, direction: node.direction, isTerminal: node.isTerminal, value: 1000)
        let children = possibleMovesNodes(node: node)
        for child in children {
            let childNode = minimaxWithAlphaBetaPruning(node: child, depth: depth - 1, alpha: alphaCopy, beta: betaCopy, isMaxPlayer: true)
            if childNode.value < currentNode.value {
                currentNode = childNode
            }
           
            if currentNode.value <= alpha {
                break
            }
            betaCopy = min(betaCopy, currentNode.value)
        }
        return currentNode
    }
}

func expectimax(node: Node, depth: Int, isMaxPlayer: Bool) -> Node {
    if depth == 0 || node.isTerminal {
        return Node(x: node.x, y: node.y, direction: node.direction, isTerminal: node.isTerminal, value: evaluatePosition(x: node.x, y: node.y, direction: node.direction))
    }
    if isMaxPlayer {
        var currentNode = Node(x: node.x, y: node.y, direction: node.direction, isTerminal: node.isTerminal, value: -1000)
        let children = possibleMovesNodes(node: node)
        for child in children {
            var childNode = expectimax(node: child, depth: depth - 1,  isMaxPlayer: false)
            childNode.value *= [Double](arrayLiteral: 0.25, 0.5, 0.75, 1).randomElement() ?? 1
            if childNode.value > currentNode.value {
                currentNode = childNode
            }
        }
        return currentNode
    } else {
        var currentNode = Node(x: node.x, y: node.y, direction: node.direction, isTerminal: node.isTerminal, value: 1000)
        let children = possibleMovesNodes(node: node)
        for child in children {
            var childNode = expectimax(node: child, depth: depth - 1,  isMaxPlayer: true)
            childNode.value *= [Double](arrayLiteral: 0.25, 0.5, 0.75, 1).randomElement() ?? 1
            if childNode.value < currentNode.value {
                currentNode = childNode
            }
        }
        return currentNode
    }
}


struct Node {
    let x: Int
    let y: Int
    let direction: Rotation
    let isTerminal: Bool
    var value: Double
}


func evaluatePosition(x: Int, y: Int, direction: Rotation) -> Double {
    var eval: Double = 0
    switch direction {
    case .up:
        for i in y..<level1.count {
            if level1[i][x] == 3 {
                eval -= Double(1) / Double(y - i)
            }
            if level1[i][x] == 1 {
                eval += 0.1
            }
        }
    case .down:
        for i in 0...y {
            if level1[i][x] == 3 {
                eval -= Double(1) / Double(y - i)
            }
            if level1[i][x] == 1 {
                eval += 0.1
            }
        }
    case .right:
        for i in x..<level1[y].count {
            if level1[y][i] == 3 {
                eval -= Double(1) / Double(x - i)
            }
            if level1[y][i] == 1 {
                eval += 0.1
            }
        }
    case .left:
        for i in 0...x {
            if level1[y][i] == 3 {
                eval -= Double(1) / Double(x - i)
            }
            if level1[y][i] == 1 {
                eval += 0.1
            }
        }
    }
    
    return eval
}
