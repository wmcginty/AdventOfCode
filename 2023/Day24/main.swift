//
//  main.swift
//  Day24
//
//  Created by Will McGinty on 11/6/23.
//

import AdventKit
import Algorithms
import Collections
import Foundation
import Parsing

struct Point {
    
    // MARK: - Properties
    var x: Double
    var y: Double
}

struct Ray {
    
    // MARK: - Properties
    var startPoint: Point
    var direction: Point
    
    // MARK: - Interface
    var slope: Double { return direction.y / direction.x }
    var yIntercept: Double {
        // y = mx + b => b = y - mx
        return startPoint.y - slope * startPoint.x
    }

    func intersection(with other: Ray) -> Point? {
        let m1 = slope
        let c1 = yIntercept
        
        let m2 = other.slope
        let c2 = other.yIntercept
        
        if m1 == m2 {
            return nil // Paralle, no intersection
        }
        
        let x = (c2 - c1) / (m1 - m2)
        let y = m1 * x + c1
        
        let intersectionPoint = Point(x: x, y: y)
        if isPointForward(point: intersectionPoint) && other.isPointForward(point: intersectionPoint) {
            return intersectionPoint
        }
        
        return nil
    }
    
    func isPointForward(point: Point) -> Bool {
        if direction.x != 0 {
            return direction.x > 0 ? point.x >= startPoint.x : point.x <= startPoint.x
        }
        
        if direction.y != 0 {
            return direction.y > 0 ? point.y >= startPoint.y : point.y <= startPoint.y
        }
        
        return false
    }
}

struct Hailstone: Hashable {
    
    // MARK: - Properties
    var positionX: Int
    var positionY: Int
    var positionZ: Int
    
    let velocityX: Int
    let velocityY: Int
    let velocityZ: Int
    
    // MARK: - Interface
    var ray: Ray {
        let startPoint = Point(x: Double(positionX), y: Double(positionY))
        let direction = Point(x: Double(velocityX), y: Double(velocityY))
        return Ray(startPoint: startPoint, direction: direction)
    }
}

struct CollisionBounds {
    
    // MARK: - Properties
    let xRange: ClosedRange<Double>
    let yRange: ClosedRange<Double>
}

let hailstones = try inputParser.parse(String.input)
measure(part: .one) {
    /* Part One */
    let collisionBounds = CollisionBounds(xRange: 200000000000000...400000000000000, yRange: 200000000000000...400000000000000)

    var collisionCount = 0
    for x in 0..<hailstones.count {
        for y in (x + 1)..<hailstones.count {
            
            let one = hailstones[x]
            let two = hailstones[y]
            
            // check for collisions
            if let intersection = one.ray.intersection(with: two.ray) {
                if collisionBounds.xRange.contains(intersection.x) && collisionBounds.yRange.contains(intersection.y) {
                    collisionCount += 1
                }
            }
        }
    }
    
    return collisionCount
}

measure(part: .two) {
    /* There was no chance this was happening in Swift. So instead, I wrote some stupid simple Python (also in repo) and cheated with https://github.com/Z3Prover/z3. */
    return 0
}

