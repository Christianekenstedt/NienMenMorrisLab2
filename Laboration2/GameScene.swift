//
//  GameScene.swift
//  Laboration2
//
//  Created by Christian Ekenstedt on 2016-11-23.
//  Copyright © 2016 Christian Ekenstedt. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene{
    
    private var label : SKLabelNode?
    private var teamBlue : [SKNode] = [SKNode]()
    private var teamRed : [SKNode] = [SKNode]()
    private var playerNames : [SKNode] = [SKNode]()
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
        initBoardPositions()
        startGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        if let touch = touches.first{
            let touchCount = touches.count
            //let touch = touches.first
            let touchLocation = touch.location(in: self)
            
            if touchCount == 3{
                restartGame(msg: ["Do you want to restart game?","Do you want to restart?"])
            }
            
            if let node = self.nodes(at: touchLocation).first {
                    print("Touched \(node.name)")
                if !hasMill{
                    if game!.whosTurnAsInt() == 1 {
                        if node.name!.contains("bc") {
                            playerMarkTouched = node
                            playerMarkOrginalPosition = node.position
                            playerMarkFrom = getPlayerMarkPositionOnBoard()
                        }
                    }else if game!.whosTurnAsInt() == 2{
                        if node.name!.contains("rc") {
                            playerMarkTouched = node
                            playerMarkOrginalPosition = node.position
                            playerMarkFrom = getPlayerMarkPositionOnBoard()
                        }
                    }
                }else {
                    if game!.whosTurnAsInt() == 2 {
                        if node.name!.contains("bc") {
                            playerMarkTouched = node
                            playerMarkOrginalPosition = node.position
                            opponentMarkPosToRemove = getPlayerMarkPositionOnBoard()
                        }
                    }else if game!.whosTurnAsInt() == 1{
                        if node.name!.contains("rc") {
                            playerMarkTouched = node
                            playerMarkOrginalPosition = node.position
                            opponentMarkPosToRemove = getPlayerMarkPositionOnBoard()
                        }
                    }
                }
            }
            if !hasMill{
                if playerMarkFrom > 0 && (game?.checkMarksInHand())! > 0 {
                    //Player is trying to move mark on board while still have marks in hand
                    playerMarkTouched = nil
                    playerMarkOrginalPosition = nil
                    playerMarkFrom = 0
                    opponentMarkPosToRemove = 0
                }
            }
        }
        /**/
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            if !hasMill{
                if playerMarkTouched != nil {
                    if let nodeToMove = self.playerMarkTouched{
                        //let touch = touches.first
                        let touchLocation = touch.location(in: self)
                        nodeToMove.position = touchLocation
                    }
                    
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if hasMill {
                if (game?.remove(from: opponentMarkPosToRemove, color: (game?.whosTurnAsInt())! == 1 ? 5 : 4 ))!{
                    print("Ta bort nod (\(playerMarkTouched!.name)) från vy.")
                    
                    if let nodeToRemove = self.playerMarkTouched{
                        nodeToRemove.removeFromParent()
                        self.playerMarkTouched = nil
                    }
                    
                    
                    alertTurn(msg: "Good choice, hand over device to \(game!.whosTurn())")
                    hasMill = false
                    if (game?.win(color: (game?.whosTurnAsInt())! == 1 ? 5 : 4 ))! {
                        restartGame(msg: ["🎉🎈 \(game!.whosTurn() == "Red" ? "Blue" : "Red") wins! 🎈🎉! Do you want to play again?","Game Over!"])
                    }
                    game?.printBoard()
                }
                
            }else{
                validateIfMoved()
                checkWhereMarkIsPlaced(dropLocation: (touches.first?.location(in: self))!)
            }
            playerMarkTouched = nil
        }
        
    }
    
    func validateIfMoved() -> Bool{
        return true
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
                    
                    if (game?.win(color: (game?.whosTurnAsInt())! == 1 ? 5 : 4 ))! {
                        restartGame(msg: ["🎉🎈 \(game!.whosTurn() == "Red" ? "Blue" : "Red") wins! 🎈🎉! Do you want to play again?","Game Over!"])
                        print("Player \(game?.whosTurn()) wins!")
                    }else if (game?.isValidMove(to: pos!, from: playerMarkFrom))!{
                        if(game?.legalMove(to: pos!, from: playerMarkFrom, color: (game?.whosTurnAsInt())!))!{
                            print("VALID MOVE!")
                            print("Move \(playerMarkTouched!.name) from e\(playerMarkFrom) to e\(pos!)")
                            if (game?.remove(to: pos!))! {
                                print("Du har mill, välj en av motståndarnas pjäs att ta bort!")
                                
                                if game?.whosTurnAsInt() == 1 {
                                    game?.setPlayerTurnTo(color: 2)
                                }else{
                                    game?.setPlayerTurnTo(color: 1)
                                }
                                showMill(who: (game?.whosTurn())!)
                                hasMill = true
                            }
                            game?.printBoard()
                            
                            
                        }
                    }else{
                        print("INVALID MOVE!")
                        break
                         // Fattar inte varför det inte går att ta setPlayerMark(resetPos!) ??????
                    }
                    
                    
                    setPlayerMark(location: bp.position)
                    
                    if(!hasMill){
                        showPlayerTurn(color: game!.whosTurn())
                    }else{
                        alertTurn(msg: "\(game!.whosTurn()) has mill! Pick opponents marker to remove!")
                    }
                    return
                }
            }
            setPlayerMark(location: resetPos!)
        
        

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
        showPlayerTurn(color: game!.whosTurn())
    }
    
    func showMill(who: String){
        let str = "\(who) has mill!"
        var label = SKLabelNode()
        label.fontName = "Helvetica Neue UltraLight"
        label.fontColor = who == "Red" ? UIColor.red : UIColor.blue
        label.text = str
        label.position = CGPoint(x: 0, y: 0 )
        label.zRotation = who == "Red" ? CGFloat(0) : CGFloat(M_PI)
        label.fontSize = 40
        var fadeOut = SKAction.fadeOut(withDuration: 6)
        self.addChild(label)
        label.run(fadeOut, completion: {action in
            label.removeFromParent()
        })
        
        
    }
    
    
    func showPlayerTurn(color: String){
        if color == "Red"{
            (playerNames[1] as! SKLabelNode).fontName = "Helvetica Neue UltraLight"
            (playerNames[1] as! SKLabelNode).fontColor = UIColor.black
            (playerNames[0] as! SKLabelNode).fontName = "Helvetica Neue UltraLight-Bold"
            (playerNames[0] as! SKLabelNode).fontColor = UIColor.red
        }else if color == "Blue"{
            (playerNames[0] as! SKLabelNode).fontName = "Helvetica Neue UltraLight"
            (playerNames[0] as! SKLabelNode).fontColor = UIColor.black
            (playerNames[1] as! SKLabelNode).fontName = "Helvetica Neue UltraLight-Bold"
            (playerNames[1] as! SKLabelNode).fontColor = UIColor.blue
        }
        
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
                }else if child.name!.contains("p"){
                    playerNames.append(child)
                }
                
            }
        }
    }
}
