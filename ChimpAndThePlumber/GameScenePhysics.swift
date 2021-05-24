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
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        guard let nameA = nodeA.name, let nameB = nodeB.name else { return }

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
            return
        }

        if oneNodeIsBarrel && oneNodeIsPlayer {
            if(nameA == "Barrel") {
                nodeA.removeFromParent()
            }
            if(nameB == "Barrel") {
                nodeB.removeFromParent()
            }
            //minus 1 life
            return
        }

    }
}

