//
//  Boid.swift
//  Flocking
//
//  Created by Alec on 5/8/20.
//  Copyright © 2020 Huff Limitied. All rights reserved.
import SpriteKit

class Boid: SKSpriteNode {

    var velocity: CGPoint = CGPoint.zero
    var seperationCommand: CGPoint?
    var alignmentCommand: CGPoint?
    var cohesionCommand: CGPoint?

//    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

}
