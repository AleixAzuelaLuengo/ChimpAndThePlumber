//
//  MainMenu.swift
//  ChimpAndThePlumber
//
//  Created by Alumne on 8/6/21.
//

import Foundation
import GameplayKit
import AVFAudio
import AVFoundation
import SpriteKit
import SwiftUI

class MainMenu : SKScene {
    public var coinSound : AVAudioPlayer!
    public var backgroundMusic : AVAudioPlayer!
    var textInput: UITextField!
    @State private var username = "Example"
    
    public var gameView : GameViewController!
    override func didMove(to view: SKView) {
        initSounds()
        let scoreLabel = SKLabelNode(text: "INSERT COIN")
        scoreLabel.fontSize = 100
        scoreLabel.position = CGPoint(x: 0, y: 500)
        self.addChild(scoreLabel)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.coinSound.play()
        gameView.currentScene = 1
        gameView.custommLoadScene()
    }
    
    func initSounds() {
        var url = Bundle.main.url(forResource: "bacmusic", withExtension: "wav")
        do {
            self.backgroundMusic = try AVAudioPlayer(contentsOf: url!)
        } catch {
            print("Unable to load sound")
        }
        url = Bundle.main.url(forResource: "coin", withExtension: "wav")
        do {
            self.coinSound = try AVAudioPlayer(contentsOf: url!)
        } catch {
            print("Unable to load sound")
        }
        self.coinSound.numberOfLoops = 1
        self.backgroundMusic.numberOfLoops = -1
        self.backgroundMusic.play()
    }
}
