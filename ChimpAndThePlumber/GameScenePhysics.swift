//
//  GameScenePhysics.swift
//  ChimpAndThePlumber
//
//  Created by Alumne on 24/5/21.
//
import SpriteKit
import GameplayKit

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node as? SKSpriteNode else { return }
        guard let nodeB = contact.bodyB.node as? SKSpriteNode else { return }
        guard let nameA = nodeA.name, let nameB = nodeB.name else { return }
               
        checkPeachContact(contact, nameA, nameB)
        checkBarrelContact(contact, nodeA, nodeB, nameA, nameB)
        checkPlayerContact(contact, nodeA, nodeB, nameA, nameB)
    }
    
    func checkPeachContact(_ contact: SKPhysicsContact, _ nameA: String, _ nameB: String) {
        let oneNodeIsPeach = nameA == "Peach" || nameB == "Peach"
        let oneNodeIsPlayer = nameA == "Plumber" || nameB == "Plumber"
        if oneNodeIsPeach && oneNodeIsPlayer {
            self.punctuation += lifes * 1000
            self.scoreLabel.text = "SCORE: \(punctuation)"
            self.playerSprite.run(self.completionSound)
            self.walkSound.stop()
            self.backgroundMusic.stop()
            self.getLeaderBoard()
            gameView.currentScene = 2
            gameView.custommLoadScene()
            return
            
        }
    }
    
    func checkBarrelContact(_ contact: SKPhysicsContact, _ nodeA: SKSpriteNode,
                            _ nodeB: SKSpriteNode,  _ nameA: String, _ nameB: String) {
        let oneNodeIsBarrel = nameA == "Barrel" || nameB == "Barrel"
        let oneNodeIsLimit = nameA == "Limit" || nameB == "Limit"
        let oneNodeIsPlayer = nameA == "Plumber" || nameB == "Plumber"
        if oneNodeIsBarrel && oneNodeIsLimit {
            if(nameA == "Barrel") {
                nodeA.removeFromParent()
            }
            if(nameB == "Barrel") {
                nodeB.removeFromParent()
            }
            self.punctuation += 200
            self.scoreLabel.text = "SCORE: \(punctuation)"
            return
        }
        if oneNodeIsBarrel && oneNodeIsPlayer {
            if(!self.playerInmortal) {
                if(self.lifes > 0 ) {
                    self.playerSprite.run(self.deathSound)
                    self.lifes -= 1
                    self.lifesLabel.text = "LIVES LEFT: \(self.lifes)"
                    self.getLeaderBoard()
                    self.resetGame()
                    self.punctuation = 0
                    self.scoreLabel.text = "SCORE: \(self.punctuation)"
                } else {
                    self.walkSound.stop()
                    self.getLeaderBoard()
                    gameView.currentScene = 2
                    gameView.custommLoadScene()
                }
            } else {
                if(nameA == "Barrel") {
                                nodeA.removeFromParent()
                            }
                if(nameB == "Barrel") {
                    nodeB.removeFromParent()
                }
                self.punctuation += 100
                self.scoreLabel.text = "SCORE: \(self.punctuation)"
            }
            return
        }
    }
    
    func checkPlayerContact(_ contact: SKPhysicsContact, _ nodeA: SKSpriteNode,
                            _ nodeB: SKSpriteNode, _ nameA: String, _ nameB: String) {
        let oneNodeIsFloor = nameA.hasPrefix("Floor") || nameB.hasPrefix("Floor")
        let oneNodeIsPlayer = nameA == "Plumber" || nameB == "Plumber"
        let oneNodeIsHammer = nameA == "Hammer" || nameB == "Hammer"
        if(oneNodeIsFloor && oneNodeIsPlayer) {
            let plumberNode : SKSpriteNode = nameA == "Plumber" ? nodeA : nodeB
            if let contactPointInView = scene?.convert(contact.contactPoint,
                                                       to: plumberNode), contactPointInView.y < 0 {
                self.resetJump()
            }
            return
        }
        if(oneNodeIsHammer && oneNodeIsPlayer && !self.playerInmortal) {
            if(nameA == "Hammer") {
                            nodeA.removeFromParent()
                        }
            if(nameB == "Hammer") {
                nodeB.removeFromParent()
            }
            self.playerSprite.run(self.powerUpSound)
            self.playerSprite.removeAction(forKey: self.walkActionKey)
            self.playerSprite.run(self.hammerAction, withKey: self.hammerActionKey)
            self.playerInmortal = true
            self.hammerSound.play()
            self.punctuation += 100
            self.scoreLabel.text = "SCORE: \(self.punctuation)"
            Timer.scheduledTimer(timeInterval: 3.5, target: self,
                                                  selector: #selector(stopHammer), userInfo: nil, repeats: false)
        }
    }
    
    func checkDKContact(_ contact: SKPhysicsContact, _ nodeA: SKSpriteNode,
                        _ nodeB: SKSpriteNode, _ nameA: String, _ nameB: String) {
        let oneNodeIsDK = nameA == "Chimp" || nameB == "Chimp"
        let oneNodeIsPlayer = nameA == "Plumber" || nameB == "Plumber"
        if(oneNodeIsDK && oneNodeIsPlayer) {
            if(!self.playerInmortal) {
                if(self.lifes > 0) {
                    self.playerSprite.run(self.deathSound)
                    self.lifes -= 1
                    self.lifesLabel.text = "LIVES LEFT: \(self.lifes)"
                    self.resetGame()
                    self.punctuation = 0
                    self.scoreLabel.text = "SCORE: \(self.punctuation)"
                } else {
                    // ENDGAME
                    self.backgroundMusic.stop()
                    self.walkSound.stop()
                    self.getLeaderBoard()
                    gameView.currentScene = 2
                    gameView.custommLoadScene()
                }
            }
            return
        }
    }
}
