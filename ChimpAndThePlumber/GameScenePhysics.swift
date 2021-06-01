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

        let oneNodeIsFloor = nameA.hasPrefix("Floor") || nameB.hasPrefix("Floor")
        let oneNodeIsBarrel = nameA == "Barrel" || nameB == "Barrel"
        let oneNodeIsLimit = nameA == "Limit" || nameB == "Limit"
        let oneNodeIsPeach = nameA == "Peach" || nameB == "Peach"
        let oneNodeIsPlayer = nameA == "Plumber" || nameB == "Plumber"

        if oneNodeIsBarrel && oneNodeIsLimit {
            if(nameA == "Barrel") {
                nodeA.removeFromParent()
            }
            if(nameB == "Barrel") {
                nodeB.removeFromParent()
            }
            punctuation += 100
            scoreLabel.text = "SCORE: \(punctuation)"
            return
        }
        
        if(oneNodeIsFloor && oneNodeIsPlayer) {
            let plumberNode : SKSpriteNode = nameA == "Plumber" ? nodeA : nodeB
            if let contactPointInView = scene?.convert(contact.contactPoint, to: plumberNode), contactPointInView.y < 0 {
                resetJump()
            }
            return
        }

        if oneNodeIsBarrel && oneNodeIsPlayer {
            if(nameA == "Barrel") {
                nodeA.removeFromParent()
            }
            if(nameB == "Barrel") {
                nodeB.removeFromParent()
            }
            punctuation -= 50
            scoreLabel.text = "SCORE: \(punctuation)"
            return
        }

    }
}
