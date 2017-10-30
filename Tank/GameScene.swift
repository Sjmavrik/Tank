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
    var playerVelocityVector = CGVector()
    var i = 0
    var timerRepeatFire = Timer()
    var moving: Bool = false
    var shooting: Bool = false
    var touch, touchR: UITouch?
    var yzero: CGFloat = 0
    var xzero: CGFloat = 0
    var player: SKSpriteNode?
    
    private var lastUpdateTime : TimeInterval = 0
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    var player: SKSpriteNode?
    var bullet: SKSpriteNode?
    
    
    override func didMove(to view: SKView) {
        player = childNode(withName: "TankPlayer") as? SKSpriteNode
        bullet = SKSpriteNode (imageNamed: "Bullet")
        bullet?.position = CGPoint (x:950, y:100)
        bullet?.size = CGSize(width: 100, height: 50)
        bullet?.zRotation = 270 * CGFloat.pi / 180
        self.addChild(bullet!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(event?.allTouches?.count as Any)
        if (touches.first?.location(in: self).x)! < 0 {
            if moving == false {
                touch = touches.first
                moving = true
                xzero = (touch?.location(in: self).x)!
                yzero = (touch?.location(in: self).y)!
            }
        } else {
            if shooting == false {
                shooting = true
                touchR = touches.first
                shoot ()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touch == touches.first {
            let tlx = touches.first?.location(in: self).x
            let tly = touches.first?.location(in: self).y
            let dx = (touches.first?.location(in: self).x)! - xzero
            let dy = (touches.first?.location(in: self).y)! - yzero
            if tlx! > xzero && abs(dx) - abs(dy) > 50 {
                player?.zRotation = 180 * CGFloat.pi / 180
                playerVelocityVector = CGVector(dx: 200, dy: 0)
                //player?.physicsBody?.velocity = CGVector(dx: 200, dy: 0)
            } else if tlx! < xzero && abs(dx) - abs(dy) > 50 {
                player?.zRotation = 0 * CGFloat.pi / 180
                playerVelocityVector = CGVector(dx: -200, dy: 0)
                //player?.physicsBody?.velocity = CGVector(dx: -200, dy: 0)
            } else if tly! > yzero && abs(dy) - abs(dx) > 50 {
                player?.zRotation = 270 * CGFloat.pi / 180
                playerVelocityVector = CGVector(dx: 0, dy: 200)
                //player?.physicsBody?.velocity = CGVector(dx: 0, dy: 200)
            } else if tly! < yzero && abs(dy) - abs(dx) > 50 {
                player?.zRotation = 90 * CGFloat.pi / 180
                playerVelocityVector = CGVector(dx: 0, dy: -200)
                //player?.physicsBody?.velocity = CGVector(dx: 0, dy: -200)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touch == touches.first {
            moving = false
            playerVelocityVector = CGVector (dx: 0, dy: 0)
        } else if touchR == touches.first {
            shooting = false
            timerRepeatFire.invalidate()
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
        
        player?.physicsBody?.velocity = playerVelocityVector
        
        for child in children {
            if child is Enemy {
                (child as! Enemy).updateMovement()
            }
        }
        
        //scene change
        
        var enemies = [Enemy]()
        for child in children {
            if child is Enemy {
                 enemies.append(child as! Enemy)
                 (child as! Enemy).updateMovement()
            }
        }
        if enemies.count == 0 {
            view?.presentScene(GameScene(fileNamed: "GameScene2"))
        }
    }
    
}

