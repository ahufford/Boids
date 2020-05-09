//
//  GameScene.swift
//  Flocking
//
//  Created by Alec on 5/8/20.
//  Copyright © 2020 Huff Limitied. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var boids: [Boid] = []

    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0

    let moveSpeed = 250.0

    var screenBounds: CGRect = CGRect.zero

    override func didMove(to view: SKView) {
        screenBounds = view.bounds
    }
    
    var x = 1
    func touchDown(atPoint pos : CGPoint) {
        let b = Boid(imageNamed: "boid")
        b.position = pos
        b.size = CGSize(width: 40, height: 40)
        b.velocity = CGPoint(x: CGFloat.random(in: -400...400), y: CGFloat.random(in: -400...400))
        //let x = Int.random(in: 1...4)
//        if x == 1{
//            b.velocity = CGPoint(x: 20, y: 0)
//        } else if x == 2{
//            b.velocity = CGPoint(x: -20, y: 0)
//        }else if x == 3{
//            b.velocity = CGPoint(x: 0, y: 20)
//        }else{
//            b.velocity = CGPoint(x: 0, y: -20)
//        }
        x += 1
        boids.append(b)
        addChild(b)
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    let degreesToRadians = CGFloat.pi / 180
    let radiansToDegrees = 180 / CGFloat.pi

    let extraAngle = CGFloat(Float.pi / 6)

    func moveSprite(sprite: Boid) {
        let ammountToMove = CGPoint(x: sprite.velocity.x * CGFloat(dt), y: sprite.velocity.y * CGFloat(dt))
        sprite.position = CGPoint(x: sprite.position.x + ammountToMove.x,
                                  y: sprite.position.y + ammountToMove.y)
        let angle = atan2(sprite.velocity.y, sprite.velocity.x)
        sprite.zRotation = angle + extraAngle

    }

    func checkBounds(sprite: Boid) {
        if sprite.position.x < screenBounds.minX {
            sprite.position.x = screenBounds.maxX
        } else if sprite.position.x > screenBounds.maxX {
            sprite.position.x = screenBounds.minX
        }
        if sprite.position.y < screenBounds.minY {
            sprite.position.y = screenBounds.maxY
        } else if sprite.position.y > screenBounds.maxY {
            sprite.position.y = screenBounds.minY
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        print("\(dt*1000) ms from last update")

        for b in boids {
            moveSprite(sprite: b)

            checkBounds(sprite: b)
        }

    }
}


// Taken from ACBRadialMenuView Project
// BSD 3-Clause License
// Copyright (c) 2017, akhilcb (https://github.com/akhilcb)
extension CGPoint {

    static func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)

        return CGPoint(x: x, y: y)
    }

    static func angleBetweenThreePoints(center: CGPoint, firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
        let firstAngle = atan2(firstPoint.y - center.y, firstPoint.x - center.x)
        let secondAnlge = atan2(secondPoint.y - center.y, secondPoint.x - center.x)
        var angleDiff = firstAngle - secondAnlge

        if angleDiff < 0 {
            angleDiff *= -1
        }

        return angleDiff
    }

    func angleBetweenPoints(firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
        return CGPoint.angleBetweenThreePoints(center: self, firstPoint: firstPoint, secondPoint: secondPoint)
    }

    func angleToPoint(pointOnCircle: CGPoint) -> CGFloat {

        let originX = pointOnCircle.x - self.x
        let originY = pointOnCircle.y - self.y
        var radians = atan2(originY, originX)

        while radians < 0 {
            radians += CGFloat(2 * Double.pi)
        }

        return radians
    }

    static func pointOnCircleAtArcDistance(center: CGPoint,
                                           point: CGPoint,
                                           radius: CGFloat,
                                           arcDistance: CGFloat,
                                           clockwise: Bool) -> CGPoint {

        var angle = center.angleToPoint(pointOnCircle: point);

        if clockwise {
            angle = angle + (arcDistance / radius)
        } else {
            angle = angle - (arcDistance / radius)
        }

        return self.pointOnCircle(center: center, radius: radius, angle: angle)

    }

    func distanceToPoint(otherPoint: CGPoint) -> CGFloat {
        return sqrt(pow((otherPoint.x - x), 2) + pow((otherPoint.y - y), 2))
    }

    static func CGPointRound(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: CoreGraphics.round(point.x), y: CoreGraphics.round(point.y))
    }

    static func intersectingPointsOfCircles(firstCenter: CGPoint, secondCenter: CGPoint, firstRadius: CGFloat, secondRadius: CGFloat ) -> (firstPoint: CGPoint?, secondPoint: CGPoint?) {

        let distance = firstCenter.distanceToPoint(otherPoint: secondCenter)
        let m = firstRadius + secondRadius
        var n = firstRadius - secondRadius

        if n < 0 {
            n = n * -1
        }

        //no intersection
        if distance > m {
            return (firstPoint: nil, secondPoint: nil)
        }

        //circle is inside other circle
        if distance < n {
            return (firstPoint: nil, secondPoint: nil)
        }

        //same circle
        if distance == 0 && firstRadius == secondRadius {
            return (firstPoint: nil, secondPoint: nil)
        }

        let a = ((firstRadius * firstRadius) - (secondRadius * secondRadius) + (distance * distance)) / (2 * distance)
        let h = sqrt(firstRadius * firstRadius - a * a)

        var p = CGPoint.zero
        p.x = firstCenter.x + (a / distance) * (secondCenter.x - firstCenter.x)
        p.y = firstCenter.y + (a / distance) * (secondCenter.y - firstCenter.y)

        //only one point intersecting
        if distance == firstRadius + secondRadius {
            return (firstPoint: p, secondPoint: nil)
        }

        var p1 = CGPoint.zero
        var p2 = CGPoint.zero

        p1.x = p.x + (h / distance) * (secondCenter.y - firstCenter.y)
        p1.y = p.y - (h / distance) * (secondCenter.x - firstCenter.x)

        p2.x = p.x - (h / distance) * (secondCenter.y - firstCenter.y)
        p2.y = p.y + (h / distance) * (secondCenter.x - firstCenter.x)

        //return both points
        return (firstPoint: p1, secondPoint: p2)
    }
}
