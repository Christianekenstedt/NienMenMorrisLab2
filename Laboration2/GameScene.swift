//
//  GameScene.swift
//  Laboration2
//
//  Created by Christian Ekenstedt on 2016-11-23.
//  Copyright © 2016 Christian Ekenstedt. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var teamBlue : [SKNode] = [SKNode]()
    private var teamRed : [SKNode] = [SKNode]()
    private var boardPositions: [SKNode] = [SKNode]()
    private var playerMarkTouched : SKNode? = nil
    private var playerMarkOrginalPosition : CGPoint? = nil
    private var playerMarkFrom : Int = 0
    private var hasMill : Bool = false
    private var opponentMarkToRemove : SKNode? = nil
    private var opponentMarkPosToRemove : Int = 0
    private var game : NineMenMorrisRules? = nil
    
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.white
        physicsWorld.contactDelegate = self
        initBoardPositions()
        startGame()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touchCount = touches.count
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if touchCount == 3{
            restartGame(msg: ["Do you want to restart game?","Do you want to restart?"])
        }
        
        if !hasMill {
            if game?.whosTurnAsInt() == 1 {
                for pm in teamBlue{
                    if pm.contains(touchLocation) {
                        playerMarkTouched = pm
                        playerMarkOrginalPosition = pm.position
                        playerMarkFrom = getPlayerMarkPositionOnBoard()
                    }
                }
            }else if game?.whosTurnAsInt() == 2 {
                for pm in teamRed{
                    if pm.contains(touchLocation) {
                        playerMarkTouched = pm
                        playerMarkOrginalPosition = pm.position
                        playerMarkFrom = getPlayerMarkPositionOnBoard()
                    }
                }
            }

        }else{ // Måste fixa så man kan deleta!!!
            if game?.whosTurnAsInt() == 2 {
                for pm in teamBlue{
                    if pm.contains(touchLocation) {
                        playerMarkTouched = pm
                        opponentMarkPosToRemove = getPlayerMarkPositionOnBoard()
                    }
                }
            }else if game?.whosTurnAsInt() == 1 {
                for pm in teamRed{
                    if pm.contains(touchLocation) {
                        playerMarkTouched = pm
                        opponentMarkPosToRemove = getPlayerMarkPositionOnBoard()
                    }
                }
            }
        }
        
        if playerMarkFrom > 0 && (game?.checkMarksInHand())! > 0 {
            //Player is trying to move mark on board while still have marks in hand
            playerMarkTouched = nil
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !hasMill{
            if playerMarkTouched != nil {
                let touch = touches.first
                let touchLocation = touch!.location(in: self)
                playerMarkTouched?.position = touchLocation
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if hasMill {
            
            if (game?.remove(from: opponentMarkPosToRemove, color: (game?.whosTurnAsInt())! == 1 ? 5 : 4 ))!{
                print("Ta bort nod (\(playerMarkTouched!.name)) från vy.")
                playerMarkTouched?.removeFromParent()
                alertTurn(msg: "Good choice, hand over device to \(game!.whosTurn())")
                hasMill = false
                playerMarkTouched = nil
            }
            
            return
        }
        checkWhereMarkIsPlaced(dropLocation: (touches.first?.location(in: self))!)
        playerMarkTouched = nil // Kanske sätta nil på annan plats
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func setPlayerMark(location : CGPoint){
        playerMarkTouched?.position = location
    }
    
    /*
     * Kanske bättre namn, typ logic eller run
     */
    func checkWhereMarkIsPlaced(dropLocation : CGPoint) {
        // Kolla var markör är placerad, behöver vi kollisionsdetektering ?? den funkar iaf
        if playerMarkTouched == nil {
            return
        }
        let resetPos = playerMarkOrginalPosition
        
        for bp in boardPositions{
            if bp.intersects(playerMarkTouched!)  { // intersects(playerMarkTouched!)
                
                let pos = Int(bp.name!.substring(from: bp.name!.index(bp.name!.startIndex, offsetBy: 1)))
                
                if (game?.win(color: (game?.whosTurnAsInt())!))! {
                    alertTurn(msg: "🎉🎈 \(game?.whosTurn()) wins! 🎈🎉")
                    print("Player \(game?.whosTurn()) wins!")
                }else if (game?.isValidMove(to: pos!, from: playerMarkFrom))!{
                    if(game?.legalMove(to: pos!, from: playerMarkFrom, color: (game?.whosTurnAsInt())!))!{
                        print("VALID MOVE!")
                        print("Move \(playerMarkTouched?.name) from e\(playerMarkFrom) to e\(pos!)")
                        if (game?.remove(to: pos!))! {
                            print("Du har mill, välj en av motståndarnas pjäs att ta bort!")
                            
                            if game?.whosTurnAsInt() == 1 {
                                game?.setPlayerTurnTo(color: 2)
                            }else{
                                game?.setPlayerTurnTo(color: 1)
                            }
                            hasMill = true
                        }
                    }
                }else{
                    print("INVALID MOVE!")
                    break // Fattar inte varför det inte går att ta setPlayerMark(resetPos!) ??????
                }
                
                setPlayerMark(location: bp.position)
                if(!hasMill){
                    alertTurn(msg: "\(game!.whosTurn())'s turn!")
                }else{
                    alertTurn(msg: "\(game!.whosTurn()) has mill! Pick opponents marker to remove!")
                }
                return
            }
        }
        setPlayerMark(location: resetPos!)

    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var fBody: SKPhysicsBody
        var sBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            fBody = contact.bodyA
            sBody = contact.bodyB
        } else {
            fBody = contact.bodyB
            sBody = contact.bodyA
        }
        
        if fBody.categoryBitMask == playerMarkTouched?.physicsBody?.categoryBitMask && sBody.categoryBitMask == boardPositions[0].physicsBody?.categoryBitMask {
            if (playerMarkTouched?.name?.contains("rc"))!{
                print("\(playerMarkTouched!.name) nuddar \(sBody.node!.name)")
            }else if (playerMarkTouched?.name?.contains("bc"))!{
                print("\(playerMarkTouched!.name) nuddar \(sBody.node!.name)")
            }
            
        }
    }
    
    func getPlayerMarkPositionOnBoard() -> Int{
        
        for bp in boardPositions{
            if bp.intersects(playerMarkTouched!) {
                return Int(bp.name!.substring(from: bp.name!.index(bp.name!.startIndex, offsetBy: 1)))!
            }
        }
        return 0
    }
    
    func startGame(){
        game = NineMenMorrisRules()
        alertTurn(msg: "Welcome to Nine Men's Morris game! Please hand over device to player 1.")
    }
    
    func restartGame(msg: [String]) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: notificationRestartIdentifier), object: msg)

    }
    
    func alertTurn(msg: String){
        NotificationCenter.default.post(name: Notification.Name(rawValue: notificationIdentifier), object: msg)
    }
    
    func initBoardPositions(){
        for child in children{
            if child.name != nil {
                if child.name!.contains("e"){
                    boardPositions.append(child)
                }else if child.name!.contains("bc"){
                    teamBlue.append(child)
                }else if child.name!.contains("rc"){
                    teamRed.append(child)
                }
                
            }
        }
    }
    
}
