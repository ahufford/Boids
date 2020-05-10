//
//  GameViewController.swift
//  Flocking
//
//  Created by Alec on 5/8/20.
//  Copyright © 2020 Huff Limitied. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var scene: GameScene?

    @IBOutlet var coheLabel: UILabel!
    @IBOutlet var aliLabel: UILabel!
    @IBOutlet var vdLabel: UILabel!
    @IBOutlet var sepLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        scene = GameScene(size:view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .aspectFit
        skView.presentScene(scene)

    }

    @IBAction func slider1(_ sender: UISlider) {
        vdLabel.text = "Distance: \(sender.value)"
        scene!.changeSightRange(value: sender.value)
        
    }
    @IBAction func slider2(_ sender: UISlider) {
        sepLabel.text = "Seperation: \(sender.value)"
        scene!.changeRepulseFactor(value: sender.value)

    }
    @IBAction func slider3(_ sender: UISlider) {
        aliLabel.text = "Alignmment: \(sender.value)"
        scene!.changeAlignmentFactor(value: sender.value)
    }
    @IBAction func slider4(_ sender: UISlider) {
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
