//
//  GameScene.swift
//  ChimpAndThePlumber
//
//  Created by Alumne on 29/4/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()
    lazy var chimpSheet : SpriteSheet = {
        return SpriteSheet(texture: SKTexture(imageNamed: "DK"), rows: 1, columns: 11, spacing: 1, margin: 1)
    }()
    lazy var chimpSprite : SKSpriteNode = { [weak self] in
        return SKSpriteNode(texture: self?.chimpSheet.textureForColumn(column: 0, row: 0))
    }()
    lazy var playerSheet : SpriteSheet = {
        return SpriteSheet(texture: SKTexture(imageNamed: "DK"), rows: 1, columns: 11, spacing: 1, margin: 1)
    }()
    lazy var playerSprite : SKSpriteNode = { [weak self] in
        return SKSpriteNode(texture: self?.playerSheet.textureForColumn(column: 0, row: 0))
    }()
    
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

        self.chimpSprite.name = "Chimp"
        self.chimpSprite.position = CGPoint(x: -250, y: 350)
        self.chimpSprite.physicsBody = SKPhysicsBody(texture: self.chimpSprite.texture!, size: self.chimpSprite.size)
        self.chimpSprite.physicsBody?.categoryBitMask = 0x00000010
        self.chimpSprite.physicsBody?.affectedByGravity = false
        self.chimpSprite.physicsBody?.contactTestBitMask = 0x00000101
        self.chimpSprite.physicsBody?.collisionBitMask = 0x11111111
        self.playerSprite.name = "Plumber"
        self.playerSprite.position = CGPoint(x: -250, y: -550)
        self.playerSprite.physicsBody = SKPhysicsBody(texture: self.playerSprite.texture!, size: self.playerSprite.size)
        self.playerSprite.physicsBody?.categoryBitMask = 0x00000010
        self.playerSprite.physicsBody?.affectedByGravity = false
        self.playerSprite.physicsBody?.contactTestBitMask = 0x00000101
        self.playerSprite.physicsBody?.collisionBitMask = 0x11111111
        self.addChild(self.chimpSprite)
        self.addChild(self.playerSprite)
    }

    func touchDown(atPoint pos: CGPoint) {
        
    }

    func touchMoved(toPoint pos: CGPoint) {
    }

    func touchUp(atPoint pos: CGPoint) {
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }

        for touch in touches { self.touchDown(atPoint: touch.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchMoved(toPoint: touch.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchUp(atPoint: touch.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchUp(atPoint: touch.location(in: self)) }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        // Initialize _lastUpdateTime if it has not already been
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dTime = currentTime - self.lastUpdateTime

        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dTime)
        }

        self.lastUpdateTime = currentTime
    }
}
