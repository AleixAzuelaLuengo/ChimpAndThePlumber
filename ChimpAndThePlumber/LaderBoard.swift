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
        self.first = SKLabelNode(text: " ")
        for aPosition in (0...Int(leaderBoardName.count - 1)) {
//            self.first.text! +=
            let label = SKLabelNode(text: "\(aPosition) " +
                           "\(leaderBoardName[aPosition].name) " +
                           "\(leaderBoardName[aPosition].score)")
            label.position = CGPoint(x: 0, y: 300 - (100 * aPosition))
            label.fontSize = 75
            self.addChild(label)
        }
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
            UserDefaults.standard.synchronize()
        } catch {
                print(error)
        }
    }
}
