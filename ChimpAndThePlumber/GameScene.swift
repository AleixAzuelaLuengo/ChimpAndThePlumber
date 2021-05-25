//
//  GameScene.swift
//  ChimpAndThePlumber
//
//  Created by Alumne on 29/4/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // GameLoop Vars
    /// Player Variables
    private var playerLives : Int = 3
    private var playerForce : Int = 0
    private var playerJumping : Bool = false
    private var playerMovingRight : Bool = false
    private var playerMovingLeft : Bool = false
    /// Game Sprites
    private var chimpSprite : SKSpriteNode!
    private var playerSprite : SKSpriteNode!
    private var peachSprite : SKSpriteNode!
    private var limitSprite : SKSpriteNode!
    /// Actions , Keys & Timers
    private var barrelTimer: Timer?
    private var walkAction : SKAction!
    private var walkActionLeft : SKAction!
    private var walkActionRight : SKAction!
    private var jumpAction : SKAction!
    private let walkActionKey = "Walk"
    private let walkActionLeftKey = "WalkLeft"
    private let walkActionRightKey = "WalkLeft"
    private let jumpActionKey = "Jump"
    
    // Animation Sprites
    /// Mario Walk Animation
    private let walkAnimation = [
        SKTexture(imageNamed: "MarioRun_1"),
        SKTexture(imageNamed: "MarioRun_2"),
        SKTexture(imageNamed: "MarioRun_3")
    ]
    private let peachAnimation = [
        SKTexture(imageNamed: "Peach_1"),
        SKTexture(imageNamed: "Peach_2"),
        SKTexture(imageNamed: "Peach_3")
    ]
    private let chimpAnimation = [
        SKTexture(imageNamed: "DK_1"),
        SKTexture(imageNamed: "DK_2")
    ]
    private let limitAnimation = [
        SKTexture(imageNamed: "Limit_1"),
        SKTexture(imageNamed: "Limit_2"),
        SKTexture(imageNamed: "Limit_3"),
        SKTexture(imageNamed: "Limit_4")
    ]
    
    // Logic Variables
    private var movementTouch: UITouch?
    private var lookingLeft = true
    private var lastUpdateTime: TimeInterval = 0
    private var label: SKLabelNode?
    private var screenSize : CGSize!
        
    override func didMove(to view: SKView) {
        // Logic Variables init
        self.screenSize = self.frame.size
        self.physicsWorld.contactDelegate = self
        self.lastUpdateTime = 0
        
        // Sprite init
        self.peachSprite = self.createPeach(at: CGPoint(x: -250, y: 300))
        self.playerSprite = self.createMario(at: CGPoint(x: -250, y: -550))
        self.chimpSprite = self.createDK(at: CGPoint(x: -50, y: 450))
        self.limitSprite = self.createLimit(at: CGPoint(x: -350, y: -590))
        
        // Sprite addChild
        self.addChild(self.chimpSprite)
        self.addChild(self.playerSprite)
        self.addChild(self.peachSprite)
        self.addChild(self.limitSprite)
        
        // Actions
        self.walkActionLeft = SKAction.repeatForever(SKAction.moveBy(x: -8, y: 0, duration: 0.05))
        self.walkActionRight = SKAction.repeatForever(SKAction.moveBy(x: 8, y: 0, duration: 0.05))
        self.jumpAction = SKAction.moveBy(x: 10, y: 200, duration: 0.25)
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: self.walkAnimation, timePerFrame: 0.15))
        let chimpAnimation = SKAction.repeatForever(SKAction.animate(with: self.chimpAnimation, timePerFrame: 0.25))
        let peachAnimation = SKAction.repeatForever(SKAction.animate(with: self.peachAnimation, timePerFrame: 0.25))
        let limitAnimation = SKAction.repeatForever(SKAction.animate(with: self.limitAnimation, timePerFrame: 0.15))
        self.barrelTimer = Timer.scheduledTimer(timeInterval: 3.5, target: self,
                                              selector: #selector(dropBarrel), userInfo: nil, repeats: true)
        // Run Action
        self.peachSprite.run(peachAnimation)
        self.limitSprite.run(limitAnimation)
        self.chimpSprite.run(chimpAnimation)
        self.dropBarrel()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard self.movementTouch == nil else {
            self.playerSprite.run(jumpAction, withKey: jumpActionKey)
            return
        }
        
        // Movement Detection
        if let touch = touches.first {
            self.movementTouch = touch
            self.playerSprite.run(self.walkAction, withKey: self.walkActionKey)
            if(touch.location(in: self).x >= 0 && !playerMovingRight) {
                moveRight()
            }
            if(touch.location(in: self).x < 0 && !playerMovingLeft) {
                moveLeft()
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches where touch == self.movementTouch {
            if(touch.location(in: self).x >= 0 && !playerMovingRight) {
                moveRight()
            }
            if(touch.location(in: self).x < 0 && !playerMovingLeft) {
                moveLeft()
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches where touch == self.movementTouch {
                cancelOutMovement()
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches where touch == self.movementTouch {
                cancelOutMovement()
        }
    }

    override func update(_ currentTime: TimeInterval) {
        
    }
}

extension GameScene {
    private func cleanBarrels() {
        for node in children {
            guard node.name == "Barrel" else { continue }
            if node.position.y > 700 || node.position.y < -700 {
                node.removeFromParent()
            }
        }
    }
    
    private func moveRight() {
        if(lookingLeft) {
            self.playerSprite.xScale *= -1
        }
        self.playerMovingRight = true
        self.playerMovingLeft = false
        self.playerSprite.removeAction(forKey: walkActionLeftKey)
        self.playerSprite.run(walkActionRight, withKey: walkActionRightKey)
        self.lookingLeft = false
    }
    
    private func moveLeft() {
        if(!lookingLeft) {
            self.playerSprite.xScale *= -1
        }
        self.playerMovingLeft = true
        self.playerMovingRight = false
        self.playerSprite.removeAction(forKey: walkActionRightKey)
        self.playerSprite.run(walkActionLeft, withKey: walkActionLeftKey)
        self.lookingLeft = true
    }
    
    private func cancelOutMovement() {
        self.movementTouch = nil
        self.playerMovingLeft = false
        self.playerMovingRight = false
        self.playerSprite.removeAction(forKey: self.walkActionKey)
        self.playerSprite.removeAction(forKey: walkActionRightKey)
        self.playerSprite.removeAction(forKey: walkActionLeftKey)
    }
    
    @objc
    private func dropBarrel() {
        self.createBarrel(at: CGPoint(x: -150, y: 300))
    }
}
