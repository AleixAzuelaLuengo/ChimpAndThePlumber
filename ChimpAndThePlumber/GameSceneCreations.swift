//
//  GameScene.swift
//  ChimpAndThePlumber
//
//  Created by Alumne on 24/5/21.
//
//
//  GameScene+Creations.swift
//  SpaceInvaders
//
//  Created by Guillermo Fernandez on 29/03/2021.
//

import SpriteKit
import GameplayKit

extension GameScene {

    func createBarrel(at position: CGPoint) {
        let sprite = SKSpriteNode(imageNamed: "Barrel")
        sprite.position = position
        sprite.name = "Barrel"
        sprite.zPosition = 1
        addChild(sprite)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.affectedByGravity = true
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.contactTestBitMask = 0x11111111
        sprite.physicsBody?.collisionBitMask = 0x11111111
        sprite.physicsBody?.friction = 0;
        sprite.physicsBody?.angularVelocity = 3;
    }

    func resetGame() {
        let deleteObjects = self.children.filter { (node) -> Bool in
            return !(node.name == "Player")
        }

        deleteObjects.forEach { (node) in
            node.removeFromParent()
        }
    }
}
