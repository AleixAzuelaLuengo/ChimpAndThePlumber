//
//  GameScene.swift
//  ChimpAndThePlumber
//
//  Created by Alumne on 29/4/21.
//

import SpriteKit
import SKTiled
import GameplayKit

class GameScene: SKScene {

    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()

    private var lastUpdateTime: TimeInterval = 0
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?

    override func sceneDidLoad() {

        self.lastUpdateTime = 0

        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        if let tilemap = SKTilemap.load(tmxFile: "Map") {
            scene?.addChild(tilemap)
        }


        // Create shape node to use during mouse interaction
        let position = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: position,
                                                               height: position),
                                                                cornerRadius: position	 * 0.3)

        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5

            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
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
