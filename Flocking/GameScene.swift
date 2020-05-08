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
    
    
    func touchDown(atPoint pos : CGPoint) {
        let b = Boid(imageNamed: "boid")
        b.position = pos
        b.size = CGSize(width: 40, height: 40)
        b.velocity = CGPoint(x: CGFloat.random(in: -400...400), y: CGFloat.random(in: -400...400))
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

    func moveSprite(sprite: Boid) {
        let ammountToMove = CGPoint(x: sprite.velocity.x * CGFloat(dt), y: sprite.velocity.y * CGFloat(dt))
        sprite.position = CGPoint(x: sprite.position.x + ammountToMove.x,
                                  y: sprite.position.y + ammountToMove.y)
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
