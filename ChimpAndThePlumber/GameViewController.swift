//
//  GameViewController.swift
//  ChimpAndThePlumber
//
//  Created by Alumne on 29/4/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    public var currentScene : Int = 0
    @IBOutlet weak var splashScreen: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splashScreen.removeFromSuperview()
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        custommLoadScene()

    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public func custommLoadScene() {
        if(currentScene == 0) {
            loadScene(name: "MainMenu")
        }
        if(currentScene == 1) {
            loadScene(name: "GameScene")
        }
        if(currentScene == 2) {
            loadScene(name: "LaderBoard")
        }
    }
    
    func loadScene(name : String) {
        if let scene = GKScene(fileNamed: name) {
            guard let view = self.view as? SKView else { return }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            // Get the SKScene from the loaded GKScene
            if(self.currentScene == 0) {
                guard let sceneNode = scene.rootNode as? MainMenu else { return }
                sceneNode.gameView = self
                sceneNode.scaleMode = .aspectFit
                view.presentScene(sceneNode)
            }
            if(self.currentScene == 1) {
                guard let sceneNode = scene.rootNode as? GameScene else { return }
                sceneNode.gameView = self
                sceneNode.scaleMode = .aspectFit
                view.presentScene(sceneNode, transition: SKTransition.doorsCloseHorizontal(withDuration: 1))
            }
            if(self.currentScene == 2) {
                guard let sceneNode = scene.rootNode as? LaderBoard else { return }
                sceneNode.gameView = self
                sceneNode.scaleMode = .aspectFit
                view.presentScene(sceneNode, transition: SKTransition.doorsCloseHorizontal(withDuration: 1))
            }
        }
    }
}
