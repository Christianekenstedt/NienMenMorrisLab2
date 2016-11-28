//
//  MorrisGameScene.swift
//  Laboration2
//
//  Created by Christian Ekenstedt on 2016-11-23.
//  Copyright © 2016 Christian Ekenstedt. All rights reserved.
//

import SpriteKit
import GameplayKit

class MorrisGameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var background = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        background = SKSpriteNode(imageNamed: "gameboard.png")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        self.addChild(background)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
