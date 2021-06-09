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
    public var currentScene : Int = 2
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
            if let scene = GKScene(fileNamed: "MainMenu") {
                // Get the SKScene from the loaded GKScene
                guard let sceneNode = scene.rootNode as? MainMenu else { return }
                sceneNode.gameView = self
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFit
                // Present the scene
                guard let view = self.view as? SKView else { return }
                view.presentScene(sceneNode, transition: SKTransition.doorsCloseHorizontal(withDuration: 1))
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
        if(currentScene == 1) {
            if let scene = GKScene(fileNamed: "GameScene") {
                // Get the SKScene from the loaded GKScene
                guard let sceneNode = scene.rootNode as? GameScene else { return }
                sceneNode.gameView = self
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFit
                // Present the scene
                guard let view = self.view as? SKView else { return }
                view.presentScene(sceneNode)
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
        if(currentScene == 2) {
            if let scene = GKScene(fileNamed: "LaderBoard") {
                // Get the SKScene from the loaded GKScene
                guard let sceneNode = scene.rootNode as? LaderBoard else { return }
                sceneNode.gameView = self
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFit
                // Present the scene
                guard let view = self.view as? SKView else { return }
                view.presentScene(sceneNode)
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
    }
}
