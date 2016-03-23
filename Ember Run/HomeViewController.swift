//
//  GameViewController.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/12/16.
//  Copyright (c) 2016 Ilya Shaisultanov. All rights reserved.
//

import UIKit
import SpriteKit

class HomeViewController: UIViewController {
    @IBAction func onStartButton(sender: UIButton) {
        if let scene = GameScene(fileNamed:"GameScene") {
            let skView = SKView(frame: self.view.frame)
            
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.size = skView.frame.size
            
            self.view.addSubview(skView)
            
            skView.presentScene(scene)
        }
    }

    @IBAction func onSettingsButton(sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DID LOAD")
    }

    override func viewWillAppear(animated: Bool) {
        print("WILL APPEAR")
    }    
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .Portrait
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
