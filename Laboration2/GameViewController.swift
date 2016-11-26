//
//  GameViewController.swift
//  Laboration2
//
//  Created by Christian Ekenstedt on 2016-11-23.
//  Copyright © 2016 Christian Ekenstedt. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var notificationIdentifier = "alert"

class GameViewController: UIViewController {
    var msg : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showWhosTurn), name: NSNotification.Name(rawValue: notificationIdentifier), object: nil)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            
            //let scene = GameScene(size: view.bounds.size)
            
            //view.presentScene(scene)
            
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func showWhosTurn(notification: NSNotification){
        let msg = notification.object as? String
        let alert = UIAlertController(title: "Next player...", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Hand over device and press me", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
