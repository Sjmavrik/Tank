//
//  GameViewController.swift
//  Tank
//111
//  Created by Артем Тюменцев on 24.10.17.
//  Copyright © 2017 Артем Тюменцев. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var currentScene = SKScene()

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                //sceneNode.scaleMode = .aspectFit
                
                //sceneNode.physicsBody = SKPhysicsBody(edgeLoopFrom: sceneNode.frame)
                //sceneNode.physicsBody?.restitution = 0
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    //view.showsPhysics = true
                    view.ignoresSiblingOrder = true
                    //view.showsFPS = true
                    //view.showsNodeCount = true
                }
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

   override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    
           return .landscape
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
