//
//  MainMenu.swift
//  ChimpAndThePlumber
//
//  Created by Alumne on 8/6/21.
//

import Foundation
import GameplayKit
import SpriteKit

class MainMenu : SKScene {
    public var scoreLabel: SKLabelNode!
    override func didMove(to view: SKView) {
        self.scoreLabel = SKLabelNode(text: "INSERT COIN")
        self.scoreLabel.fontSize = 50
        self.scoreLabel.fontName = "Retro"
        self.scoreLabel.position = CGPoint(x: 0, y: -50)
        self.addChild(self.scoreLabel)
    }
}
