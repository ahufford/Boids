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

    //TODO: Wrap Detection around screen
    //      dont find boids behind your in some range
    //      add sliders
/********************************************************/
    // There are 3 functions that are called in update function at the end of the file
    // that can be commented to change the functionality
    let showCommands = false
    let repulseFactor: CGFloat = 3.0
    let maxVelocity = 100.0 // pixel per second??
    let maxTurn = CGFloat.pi / 4 // rads per second
    let sightRange: CGFloat = 100.0
    let alignmentFactor: CGFloat = 15
/********************************************************/

    var boids: [Boid] = []
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var touchPos: CGPoint?
    var screenBounds: CGRect = CGRect.zero

    override func didMove(to view: SKView) {
        screenBounds = view.bounds
        touchPos = nil

        var b = Boid(imageNamed: "boid")
        b.position = view.center
        b.size = CGSize(width: 20, height: 20)
        b.velocity = CGPoint(x: 0, y: -40)
        boids.append(b)
        addChild(b)

        b = Boid(imageNamed: "boid")
        b.position = view.center + CGPoint(x: 0, y: 50)
        b.size = CGSize(width: 20, height: 20)
        b.velocity = CGPoint(x: -40, y: 0)
        boids.append(b)
        addChild(b)


    }
    
    var x = 1
    func touchDown(atPoint pos : CGPoint) {
        let b = Boid(imageNamed: "boid")
        b.position = pos
        b.size = CGSize(width: 20, height: 20)
        //b.velocity = CGPoint(x: CGFloat.random(in: -400...400), y: CGFloat.random(in: -400...400))
        if x%2 == 0 {
            b.velocity = CGPoint(x: 0, y: -40)
        } else {
            b.velocity = CGPoint(x: -40, y: 00)
        }
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
        x+=1
        boids.append(b)
        addChild(b)
        touchPos = pos
        touchSprite(point: pos, color: .orange)

    }
    
    func touchMoved(toPoint pos : CGPoint) {
        touchSprite(point: pos, color: .orange)
        touchPos = pos

    }
    
    func touchUp(atPoint pos : CGPoint) {
        touchPos = nil

    }

    func touchSprite(point: CGPoint, color: UIColor) {
        let centerSprite = SKSpriteNode(color: color, size: CGSize(width: 4, height: 4))
        centerSprite.position = point

        let wait = SKAction.wait(forDuration: 0.1)
        let remove = SKAction.removeFromParent()
        let seq = SKAction.sequence([wait, remove])
        centerSprite.run(seq)
        addChild(centerSprite)
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
        let angle = atan2(sprite.velocity.y, sprite.velocity.x)

        var totalCommand = sprite.position
        if sprite.cohesionCommand != nil {
            totalCommand += sprite.cohesionCommand! - sprite.position
        }
        if sprite.seperationCommand != nil {
            totalCommand += sprite.seperationCommand! - sprite.position
        }
        if sprite.alignmentCommand != nil {
            totalCommand += sprite.alignmentCommand! - sprite.position
        }

        if showCommands {
            touchSprite(point: sprite.alignmentCommand ?? CGPoint.zero, color: .red)
            touchSprite(point: sprite.cohesionCommand ?? CGPoint.zero, color: .green)
            touchSprite(point: sprite.seperationCommand ?? CGPoint.zero, color: .blue)
            touchSprite(point: totalCommand, color: .white)
        }


        if totalCommand != sprite.position {
            let commandedAngle = sprite.position.angleToPoint(pointOnCircle: totalCommand)
            var angleError = commandedAngle - angle
            if angleError > CGFloat.pi {
                angleError -= (2 * CGFloat.pi)
            }
            var newAngle = angle
            if angleError > 0 {
                newAngle = angle + (maxTurn * CGFloat(dt))
            } else {
                newAngle = angle - (maxTurn * CGFloat(dt))
            }
            sprite.velocity.x = cos(newAngle) * CGFloat(maxVelocity)
            sprite.velocity.y = sin(newAngle) * CGFloat(maxVelocity)

        }

        let ammountToMove = CGPoint(x: sprite.velocity.x * CGFloat(dt), y: sprite.velocity.y * CGFloat(dt))
        sprite.position = CGPoint(x: sprite.position.x + ammountToMove.x,
                                  y: sprite.position.y + ammountToMove.y)
        sprite.zRotation = angle + extraAngle
        checkBounds(sprite: sprite)

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

    func seperation(sprite: Boid) {
        let localBoids = getLocalBoids(sprite: sprite)
        let count = localBoids.count
        if count != 0 {

            var runPoint: CGPoint = sprite.position
            for b in localBoids {
                // This is the distance of X and Y
                var distance = sprite.position - b.position
                distance *= pow(1 - (distance.length() / sightRange), 2) * repulseFactor
                runPoint += distance

            }
            sprite.seperationCommand = runPoint
        } else {
            sprite.seperationCommand = nil
        }
    }

    func alignment(sprite: Boid) {
        let localBoids = getLocalBoids(sprite: sprite)
        let count = localBoids.count
        if count != 0 {
            var totalVelocity = CGPoint.zero
            for b in localBoids {
                totalVelocity += b.velocity
            }
            var averageAngle = atan2(totalVelocity.y, totalVelocity.x)
            if averageAngle < 0 {
                averageAngle += CGFloat.pi * 2
            }

            let spriteAngle = sprite.position.angleToPoint(pointOnCircle: sprite.position + sprite.velocity)
            let angDiff = averageAngle - spriteAngle
            // This is a need for left turn
            var vectorAngle: CGFloat = 0.0
            if angDiff > 0 {
                vectorAngle = spriteAngle + (CGFloat.pi / 2)
            } else {
                vectorAngle = spriteAngle - (CGFloat.pi / 2)
            }
            if vectorAngle > 2 * CGFloat.pi {
                vectorAngle -= 2 * CGFloat.pi
            }
            if vectorAngle < 0 {
                vectorAngle += 2 * CGFloat.pi
            }
            let alignment = (CGPoint(angle: vectorAngle) * alignmentFactor + sprite.position)

            sprite.alignmentCommand = alignment

        } else {
            sprite.alignmentCommand = nil
        }
    }

    func cohesion(sprite: Boid) {
        let localBoids = getLocalBoids(sprite: sprite)
        let count = localBoids.count
        if count != 0 {
            var centerPoint: CGPoint = CGPoint.zero
            for b in localBoids {
                centerPoint = b.position + centerPoint
            }
            centerPoint.x = centerPoint.x / CGFloat(count)
            centerPoint.y = centerPoint.y / CGFloat(count)

            sprite.cohesionCommand = centerPoint
        } else {
            sprite.cohesionCommand = nil
        }

    }


    func getLocalBoids(sprite: Boid) -> [Boid] {
        var localBoids: [Boid] = []
        for b in boids {
            let distance = sprite.position.distanceToPoint(otherPoint: b.position)
            if distance < sightRange && distance != 0 {
                localBoids.append(b)
            }
        }
        return localBoids
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        //print("\(dt*1000) ms from last update")

        for b in boids {
            // Comment these 3 to add or remove behaviors
            seperation(sprite: b)
            alignment(sprite: b)
            cohesion(sprite: b)

            moveSprite(sprite: b)

        }

    }
}


