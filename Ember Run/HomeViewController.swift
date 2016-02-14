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
        performSegueWithIdentifier("GameVC", sender: nil) // fix this to make pretty transition
    }

    @IBAction func onSettingsButton(sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
