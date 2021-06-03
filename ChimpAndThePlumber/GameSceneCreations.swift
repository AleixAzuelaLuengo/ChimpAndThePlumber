//
//  GameScene.swift
//  ChimpAndThePlumber
//
//  Created by Alumne on 24/5/21.
//

import SpriteKit
import GameplayKit

extension GameScene {
    func createPeach(at position: CGPoint) -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: "Peach_1")
        sprite.name = "Peach"
        sprite.scale(to: CGSize(width: 103, height: 84))
        sprite.position = position
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.affectedByGravity = true
        sprite.physicsBody?.contactTestBitMask = 0x00000001
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.collisionBitMask = 0x11111111
        return sprite
    }
    
    func createDK(at position: CGPoint) -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: "DK_1")
        sprite.name = "Chimp"
        sprite.position = position
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 0x00000000
        sprite.physicsBody?.affectedByGravity = true
        sprite.physicsBody?.contactTestBitMask = 0x00000000
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.collisionBitMask = 0x11111111
        return sprite
    }
    
    func createMario(at position: CGPoint) -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: "MarioRun_1")
        sprite.name = "Plumber"
        sprite.scale(to: CGSize(width: 36, height: 52))
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sprite.position = position
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.affectedByGravity = true
        sprite.physicsBody?.contactTestBitMask = 0x00000001
        sprite.physicsBody?.collisionBitMask = 0x11111111
        return sprite
    }
    
    func createLimit(at position: CGPoint) -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: "Limit_1")
        sprite.name = "Limit"
        sprite.scale(to: CGSize(width: 56, height: 88))
        sprite.position = position
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 0x00000010
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.affectedByGravity = true
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.contactTestBitMask = 0x11111111
        sprite.physicsBody?.collisionBitMask = 0x11111111
        return sprite
    }
    
    func createBarrel(at position: CGPoint) {
        let sprite = SKSpriteNode(imageNamed: "Barrel")
        sprite.position = position
        sprite.name = "Barrel"
        sprite.scale(to: CGSize(width: 26, height: 26))
        sprite.zPosition = 1
        addChild(sprite)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.affectedByGravity = true
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.contactTestBitMask = 0x00000001
        sprite.physicsBody?.collisionBitMask = 0x11111111
        sprite.physicsBody?.friction = 0
        sprite.physicsBody?.angularVelocity = 3
    }

    func resetGame() {
        // remove player and barrels
        cleanBarrels()
        self.playerSprite.removeFromParent()
        
        self.scoreLabel.text = "SCORE: 0"
        self.playerSprite = self.createMario(at: CGPoint(x: -250, y: -550))

        self.addChild(self.playerSprite)
        }
}
