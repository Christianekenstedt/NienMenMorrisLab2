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
var notificationRestartIdentifier = "restart"
var notificationGlowIdentifier = "glow"

class GameViewController: UIViewController {
    var msg : String? = nil
    
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var newGameBtn: UIButton!
    
    
    var scene : SKScene? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showWhosTurn), name: NSNotification.Name(rawValue: notificationIdentifier), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showResetOption), name: NSNotification.Name(rawValue: notificationRestartIdentifier), object: nil)
        
        
        
        
            }
    @IBAction func newGameBtnPressed(_ sender: Any) {
        hideStartScene(bool: true)
        showGamePlayScene()
    }
    
    func hideStartScene(bool: Bool){
        gameLabel.isHidden = bool
        newGameBtn.isHidden = bool
        tipLabel.isHidden = bool
    }
    
    
    
    func showGamePlayScene(){
        if let view = self.view as! SKView? {
            
            scene = SKScene(fileNamed: "GameScene")!
            if scene != nil {
                
                // Set the scale mode to scale to fit the window
                scene?.scaleMode = .aspectFit
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }

    }
    
    
    
    
    func showWhosTurn(notification: NSNotification){
        //DispatchQueue.global(qos: .background).async{
            let msg = notification.object as? String
            let alert = UIAlertController(title: "Game Alert!", message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Press me when read and understand 🙃", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        //}
    }
    func showResetOption(notification: NSNotification){
        //DispatchQueue.global(qos: .background).async{
            let msg = notification.object as? [String]
            let alert = UIAlertController(title: msg![1], message: msg![0], preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Restart game", style: UIAlertActionStyle.destructive, handler: {action in
                self.showGamePlayScene()
            }))
        alert.addAction(UIAlertAction(title: "Return to menu", style: UIAlertActionStyle.default, handler: {action in
            if let view = self.view as! SKView?{
                view.presentScene(nil)
                self.hideStartScene(bool: false)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        //}
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
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
       print("rotating...")
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if fromInterfaceOrientation.isPortrait {
            
        }
    }
    
    func changeOriantaionScene(sceneName: String){
        
        
    }
    
    
}
