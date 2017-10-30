//  wewew
//  GameScene.swift
//  Tank
//
//  Created by Артем Тюменцев on 24.10.17.
//  Copyright © 2017 Артем Тюменцев. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var moving: Bool = false
    var touch: UITouch?
    var tlx, dx: CGFloat?
    var tly, dy: CGFloat?
    var yzero: CGFloat = 0
    var xzero: CGFloat = 0
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    var player: SKSpriteNode?
    var bullet: SKSpriteNode?
    
    override func sceneDidLoad() {
        player = childNode(withName: "TankPlayer") as? SKSpriteNode
        bullet = SKSpriteNode (imageNamed: "Bullet")
        bullet?.position = CGPoint (x:950, y:100)
        bullet?.size = CGSize(width: 100, height: 50)
        bullet?.zRotation = 270 * CGFloat.pi / 180
        self.addChild(bullet!)
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if moving == false {
            touch = touches.first
            moving = true
            xzero = (touch?.location(in: self).x)!
            yzero = (touch?.location(in: self).y)!
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touch == touches.first {
            tlx = touches.first?.location(in: self).x
            tly = touches.first?.location(in: self).y
            dx = (touches.first?.location(in: self).x)! - xzero
            dy = (touches.first?.location(in: self).y)! - yzero
            if tlx! > xzero && abs(dx!) - abs(dy!) > 50 {
                player?.zRotation = 180 * CGFloat.pi / 180
                player?.physicsBody?.velocity = CGVector(dx: 200, dy: 0)
            } else if tlx! < xzero && abs(dx!) - abs(dy!) > 50 {
                player?.zRotation = 0 * CGFloat.pi / 180
                player?.physicsBody?.velocity = CGVector(dx: -200, dy: 0)
            } else if tly! > yzero && abs(dy!) - abs(dx!) > 50 {
                player?.zRotation = 270 * CGFloat.pi / 180
                player?.physicsBody?.velocity = CGVector(dx: 0, dy: 200)
            } else if tly! < yzero && abs(dy!) - abs(dx!) > 50 {
                player?.zRotation = 90 * CGFloat.pi / 180
                player?.physicsBody?.velocity = CGVector(dx: 0, dy: -200)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touch == touches.first {
            moving = false
            player?.physicsBody?.velocity = CGVector (dx: 0, dy: 0)
        }
    }
   
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
}
