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
    private var playerLives : Int = 3
    private var playerForce : Int = 0
    private var playerMoving : Bool = false
    private var movementTouch: UITouch?
    private var chimpSprite : SKSpriteNode!
    private var playerSprite : SKSpriteNode!
    private var peachSprite : SKSpriteNode!
    private var barrelTimer: Timer?
    
    private let walkAnimation = [
        SKTexture(imageNamed: "MarioRun_1"),
        SKTexture(imageNamed: "MarioRun_2"),
        SKTexture(imageNamed: "MarioRun_3")
    ]
    private var walkAction : SKAction!
    let walkActionKey = "Walk"
    
    private let peachAnimation = [
        SKTexture(imageNamed: "Peach_1"),
        SKTexture(imageNamed: "Peach_2"),
        SKTexture(imageNamed: "Peach_3")
    ]
    private let chimpAnimation = [
        SKTexture(imageNamed: "DK_1"),
        SKTexture(imageNamed: "DK_2")
    ]
    
    private var lastUpdateTime: TimeInterval = 0
    private var label: SKLabelNode?

    override func didMove(to view: SKView) {

        self.lastUpdateTime = 0

        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        // Sprite Initialization
        // DK
        self.chimpSprite = SKSpriteNode(imageNamed: "DK_1")
        self.chimpSprite.name = "Chimp"
        self.chimpSprite.position = CGPoint(x: -50, y: 450)
        self.chimpSprite.physicsBody = SKPhysicsBody(texture: self.chimpSprite.texture!, size: self.chimpSprite.size)
        self.chimpSprite.physicsBody?.categoryBitMask = 0x00000010
        self.chimpSprite.physicsBody?.affectedByGravity = true
        self.chimpSprite.physicsBody?.contactTestBitMask = 0x00000101
        self.chimpSprite.physicsBody?.collisionBitMask = 0x11111111
        // Mario
        self.playerSprite = SKSpriteNode(imageNamed: "MarioRun_1")
        self.playerSprite.name = "Plumber"
        self.playerSprite.scale(to: CGSize(width: 36, height: 52))
        self.playerSprite.position = CGPoint(x: -250, y: -550)
        self.playerSprite.physicsBody = SKPhysicsBody(texture: self.playerSprite.texture!, size: self.playerSprite.size)
        self.playerSprite.physicsBody?.allowsRotation = false
        self.playerSprite.physicsBody?.categoryBitMask = 0x00000010
        self.playerSprite.physicsBody?.affectedByGravity = true
        self.playerSprite.physicsBody?.contactTestBitMask = 0x00000101
        self.playerSprite.physicsBody?.collisionBitMask = 0x11111111
        // Peach
        self.peachSprite = SKSpriteNode(imageNamed: "Peach_1")
        self.peachSprite.name = "Peach"
        self.peachSprite.scale(to: CGSize(width: 103, height: 84))
        self.peachSprite.position = CGPoint(x: -250, y: 300)
        self.peachSprite.physicsBody = SKPhysicsBody(texture: self.peachSprite.texture!, size: self.peachSprite.size)
        self.peachSprite.physicsBody?.categoryBitMask = 0x00000010
        self.playerSprite.physicsBody?.allowsRotation = false
        self.peachSprite.physicsBody?.affectedByGravity = true
        self.peachSprite.physicsBody?.contactTestBitMask = 0x00000101
        self.peachSprite.physicsBody?.collisionBitMask = 0x11111111
        
        self.addChild(self.chimpSprite)
        self.addChild(self.playerSprite)
        self.addChild(self.peachSprite)
        
        // Actions
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: self.walkAnimation, timePerFrame: 0.15))
        let chimpAnimation = SKAction.repeatForever(SKAction.animate(with: self.chimpAnimation, timePerFrame: 0.25))
        self.chimpSprite.run(chimpAnimation)
        let peachAnimation = SKAction.repeatForever(SKAction.animate(with: self.peachAnimation, timePerFrame: 0.25))
        self.peachSprite.run(peachAnimation)
        
        self.barrelTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self,
                                              selector: #selector(dropBarrel), userInfo: nil, repeats: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard self.movementTouch == nil else {
            self.playerSprite.position.y += CGFloat(5 * Double(self.playerForce))
            self.playerSprite.removeAction(forKey: self.walkActionKey)
            return
        }
        
        // Movement Detection
        if let touch = touches.first {
            self.movementTouch = touch
            self.playerMoving = true
            self.playerSprite.run(self.walkAction, withKey: self.walkActionKey)
            if(touch.location(in: self).x > UIScreen.main.bounds.width/2) {
                self.playerForce = 1
                self.playerSprite.xScale = -1
            }
            if(touch.location(in: self).x < UIScreen.main.bounds.width/2) {
                self.playerForce = -1
                self.playerSprite.xScale = 1
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == self.movementTouch {
                if(touch.location(in: self).x > UIScreen.main.bounds.width/2) {
                    self.playerForce = 1
                    self.playerSprite.xScale = -1
                }
                if(touch.location(in: self).x < UIScreen.main.bounds.width/2) {
                    self.playerForce = -1
                    self.playerSprite.xScale = 1
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == self.movementTouch {
                self.movementTouch = nil
                self.playerMoving = false
                self.playerSprite.removeAction(forKey: self.walkActionKey)
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == self.movementTouch {
                self.movementTouch = nil
                self.playerMoving = false
                self.playerSprite.removeAction(forKey: self.walkActionKey)
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        // Initialize _lastUpdateTime if it has not already been
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dTime = currentTime - self.lastUpdateTime


        self.lastUpdateTime = currentTime
        
        if(playerMoving) {
            self.playerSprite.position.x += CGFloat(5 * Double(self.playerForce))
        }
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

    @objc
    private func dropBarrel() {
        
    }
}
