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
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var debugLabel: UILabel!

    @IBOutlet var slider1: UISlider!
    @IBOutlet var slider2: UISlider!
    @IBOutlet var slider3: UISlider!
    @IBOutlet var slider4: UISlider!
    @IBOutlet var slider5: UISlider!


    @IBOutlet var switch1: UISwitch!
    @IBOutlet var switch2: UISwitch!

    var hidden = false
    override func viewDidLoad() {
        super.viewDidLoad()
        scene = GameScene(size:view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .aspectFit
        skView.presentScene(scene)
        self.becomeFirstResponder() // To get shake gesture

        vdLabel.text = "Distance: \(scene!.sightRange)"
        sepLabel.text = "Seperation: \(scene!.repulseFactor)"
        aliLabel.text = "Alignmment: \(scene!.alignmentFactor)"
        speedLabel.text = "Speed: \(scene!.maxVelocity)"
        angleLabel.text = "Turn Rate: \(scene!.maxTurn)"




    }

    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            scene!.destroyNodes()
        }
    }
    @IBAction func hide(_ sender: Any) {
        hidden = !hidden
        coheLabel.isHidden = hidden
        aliLabel.isHidden = hidden
        vdLabel.isHidden = hidden
        sepLabel.isHidden = hidden
        speedLabel.isHidden = hidden
        angleLabel.isHidden = hidden
        debugLabel.isHidden = hidden

        slider1.isHidden = hidden
        slider2.isHidden = hidden
        slider3.isHidden = hidden
        slider4.isHidden = hidden
        slider5.isHidden = hidden

        switch1.isHidden = hidden
        switch2.isHidden = hidden
    }

    @IBAction func slider1(_ sender: UISlider) {
        vdLabel.text = "Distance: \(sender.value.rounded())"
        scene!.changeSightRange(value: sender.value)
        
    }
    @IBAction func slider2(_ sender: UISlider) {
        sepLabel.text = "Seperation: \(sender.value)"
        scene!.changeRepulseFactor(value: sender.value)

    }
    @IBAction func slider3(_ sender: UISlider) {
        aliLabel.text = "Alignmment: \(sender.value.rounded())"
        scene!.changeAlignmentFactor(value: sender.value)
    }
    @IBAction func slider4(_ sender: UISlider) {
        speedLabel.text = "Speed: \(sender.value.rounded())"
        scene!.changeSpeed(value: sender.value)

    }
    @IBAction func slider5(_ sender: UISlider) {
        angleLabel.text = "Turn Rate: \(sender.value.rounded())"
        scene!.changeAngle(value: sender.value)

    }

    @IBAction func `switch`(_ sender: UISwitch) {
        scene!.debugSwitch(value: sender.isOn)
    }
    @IBAction func switch2(_ sender: UISwitch) {
        scene!.changeCoheson(value:sender.isOn)

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
