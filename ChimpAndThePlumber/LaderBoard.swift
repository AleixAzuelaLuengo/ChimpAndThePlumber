//
//  LaderBoard.swift
//  ChimpAndThePlumber
//
//  Created by Alumne on 9/6/21.
//

import Foundation
import GameplayKit
import SpriteKit
import SwiftUI

class LaderBoard : SKScene {
    static public let LEADERBOARDKEY = "com.enti.romannumeral.leaderboard"
    public var leaderBoardName = [LeadboardScore]()
    public var first: SKLabelNode!
    public var second: SKLabelNode!
    public var third: SKLabelNode!
    public var fourth: SKLabelNode!
    public var fifth: SKLabelNode!
    public var gameView : GameViewController!
    override func didMove(to view: SKView) {
        getLeaderBoard()
        self.first = SKLabelNode(text: "")
        self.second = SKLabelNode(text: "")
        self.third = SKLabelNode(text: "")
        self.fourth = SKLabelNode(text: "")
        self.fifth = SKLabelNode(text: "")
        self.first.text = " 1. \(leaderBoardName[0].name)  \(leaderBoardName[0].score)"
        self.first.position = CGPoint(x: 0, y: 300)
        self.first.fontSize = 75
        self.second.text = " 2. \(leaderBoardName[1].name)  \(leaderBoardName[1].score)"
        self.second.position = CGPoint(x: 0, y: 150)
        self.second.fontSize = 75
        self.third.text = " 3. \(leaderBoardName[2].name)  \(leaderBoardName[2].score)"
        self.third.position = CGPoint(x: 0, y: 0)
        self.third.fontSize = 75
        self.fourth.text = " 4. \(leaderBoardName[3].name)  \(leaderBoardName[3].score)"
        self.fourth.position = CGPoint(x: 0, y: -150)
        self.fourth.fontSize = 75
        self.fifth.text = " 5. \(leaderBoardName[4].name)  \(leaderBoardName[4].score)"
        self.fifth.position = CGPoint(x: 0, y: -300)
        self.fifth.fontSize = 75

        self.addChild(self.first)
        self.addChild(self.second)
        self.addChild(self.third)
        self.addChild(self.fourth)
        self.addChild(self.fifth)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameView.currentScene = 1
        gameView.custommLoadScene()
    }
    
    public func getLeaderBoard() {
        if let leaderboardObject = UserDefaults.standard.value(forKey: GameScene.LEADERBOARDKEY)  as? Data {
            do {
                let calls = try JSONDecoder().decode([LeadboardScore].self, from: leaderboardObject)
                leaderBoardName.removeAll()
                leaderBoardName.append(contentsOf: calls)
                
            } catch {
                print("Unable to decode calls")
            }
        } else {
            print("Value not found")
        }
        leaderBoardName = leaderBoardName.sorted { $0.score > $1.score }
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
}
