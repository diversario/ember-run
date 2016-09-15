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
    @IBAction func onStartButton(_ sender: UIButton) {
        if let scene = GameScene(fileNamed:"GameScene") {
            let skView = SKView(frame: self.view.frame)
            
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
            skView.showsFields = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            scene.size = skView.frame.size
            
            self.view.addSubview(skView)
            
            skView.presentScene(scene)
        }
    }

    @IBAction func onSettingsButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DID LOAD")
    }

    override func viewWillAppear(_ animated: Bool) {
        print("WILL APPEAR")
    }    
    
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
