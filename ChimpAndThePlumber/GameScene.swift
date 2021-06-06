//
//  GameScene.swift
//  ChimpAndThePlumber
//
//  Created by Alumne on 29/4/21.
//

import SpriteKit
import AVFAudio
import GameplayKit

class GameScene: SKScene {
    // GameLoop Vars
    /// GameVars
    static public let LEADERBOARDKEY = "com.enti.romannumeral.leaderboard"
    public var leaderBoardName = [String]()
    public var scoreLabel: SKLabelNode!
    public var lifesLabel: SKLabelNode!
    public var punctuation : Int = 0
    public var lifes = 5
    private var nickname : String = ""
    /// Player Variables
    private var playerLives : Int = 3
    public var playerInmortal : Bool = false
    private var playerForce : Int = 0
    public var playerJumping : Bool = false
    private var playerMovingRight : Bool = false
    private var playerMovingLeft : Bool = false
    /// Game Sprites
    public var chimpSprite : SKSpriteNode!
    public var playerSprite : SKSpriteNode!
    public var peachSprite : SKSpriteNode!
    public var limitSprite : SKSpriteNode!
    /// Actions , Keys & Timers
    private var barrelTimer: Timer?
    public var walkAction : SKAction!
    private var walkActionLeft : SKAction!
    private var walkActionRight : SKAction!
    public var hammerAction : SKAction!
    private var jumpAction : SKAction!
    public var jumpSound : SKAction!
    public var walkSound = AVAudioPlayer()
    public var hammerSound = AVAudioPlayer()
    public var powerUpSound : SKAction!
    public var deathSound : SKAction!
    public var completionSound : SKAction!
    public var backgroundMusic = AVAudioPlayer()
    public  let walkActionKey = "Walk"
    public  let hammerActionKey = "Hammer"
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
    private let hammerAnimation = [
        SKTexture(imageNamed: "Hammer_1"),
        SKTexture(imageNamed: "Hammer_2"),
        SKTexture(imageNamed: "Hammer_3")
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
        
        //SoundInit
        self.initSounds()
        
        // Sprite init
        self.scoreLabel = SKLabelNode(text: "SCORE: 0")
        self.scoreLabel.position = CGPoint(x: 150, y: (self.size.height / 2) - 100)
        self.lifesLabel = SKLabelNode(text: "LIVES LEFT: 5")
        self.lifesLabel.position = CGPoint(x: -150, y: (self.size.height / 2) - 100)
        self.peachSprite = self.createPeach(at: CGPoint(x: -250, y: 300))
        self.playerSprite = self.createMario(at: CGPoint(x: -250, y: -550))
        self.chimpSprite = self.createDK(at: CGPoint(x: -50, y: 450))
        self.limitSprite = self.createLimit(at: CGPoint(x: -350, y: -590))
        
        // Sprite addChild
        self.addChild(self.scoreLabel)
        self.addChild(self.lifesLabel)
        self.addChild(self.chimpSprite)
        self.addChild(self.playerSprite)
        self.addChild(self.peachSprite)
        self.addChild(self.limitSprite)
        self.addChild(self.createHammer(at: CGPoint(x: 50 , y: -200)))
        self.addChild(self.createHammer(at: CGPoint(x: 50 , y: -550)))
        
        // Actions
        self.walkActionLeft = SKAction.repeatForever(SKAction.moveBy(x: -8, y: 0, duration: 0.05))
        self.walkActionRight = SKAction.repeatForever(SKAction.moveBy(x: 8, y: 0, duration: 0.05))
        self.jumpAction = SKAction.moveBy(x: 10, y: 200, duration: 0.25)
        self.hammerAction = SKAction.repeatForever(SKAction.animate(with: self.hammerAnimation, timePerFrame: 0.15))
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
            guard self.playerJumping == true else {
                jump()
                return
            }
            return
        }
        
        // Movement Detection
        if let touch = touches.first {
            self.walkSound.play()
            self.movementTouch = touch
            if(!playerInmortal) {
                self.playerSprite.run(self.walkAction, withKey: self.walkActionKey)
            } else {
                self.playerSprite.run(self.hammerAction, withKey: self.walkActionKey)
            }
            
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
    public func cleanBarrels() {
        for node in children {
            guard node.name == "Barrel" else { continue }
                node.removeFromParent()
        }
    }
    
    public func getLeaderBoard() {
        if let leaderboardObject = UserDefaults.standard.value(forKey: GameScene.LEADERBOARDKEY)  as? Data {
            do {
                let calls = try JSONDecoder().decode([String].self, from: leaderboardObject)
                leaderBoardName.removeAll()
                leaderBoardName.append(contentsOf: calls)
                
            } catch {
                print("Unable to decode calls")
            }
        } else {
            print("Value not found")
        }
        let temp = "\(punctuation) \(nickname)"
        leaderBoardName.append(temp)
        leaderBoardName = leaderBoardName.sorted { $0.lowercased() < $1.lowercased() }
        if(leaderBoardName.count > 5) {
            leaderBoardName.remove(at: leaderBoardName.count - 1)
        }
        writeLeaderboard()
        print(leaderBoardName)
    }
    
    public func writeLeaderboard() {
        do {
            let data = try JSONEncoder().encode(leaderBoardName)
            UserDefaults.standard.setValue(data, forKey: GameScene.LEADERBOARDKEY)
        } catch {
                print(error)
        }
    }
    
    private func jump() {
        self.playerSprite.run(self.jumpSound)
        self.playerSprite.run(jumpAction, withKey: jumpActionKey)
        self.playerJumping = true
    }
    
    public func resetJump() {
        self.playerJumping = false
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
        self.walkSound.stop()
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
    
    @objc
    public func stopHammer() {
        self.hammerSound.stop()
        self.playerInmortal = false
        self.playerSprite.removeAction(forKey: self.hammerActionKey)
        if(playerMovingLeft || playerMovingRight) {
            self.playerSprite.run(self.walkAction, withKey: self.walkActionKey)
        } else {
            self.playerSprite.texture = SKTexture(imageNamed: "MarioRun_1")
        }
    }
    
    func resetGame() {
        // remove player and barrels
        cleanBarrels()
        self.playerMovingLeft = false
        self.lookingLeft = true
        self.playerMovingRight = false
        self.playerSprite.removeFromParent()
        self.punctuation = 0
        self.scoreLabel.text = "SCORE: 0"
        self.playerSprite = self.createMario(at: CGPoint(x: -250, y: -550))

        self.addChild(self.playerSprite)
    }
}
