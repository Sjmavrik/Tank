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
    var i = 0
    var timer: Timer!
    var enemies = [SKSpriteNode]()
    var moving: Bool = false
    var touch: UITouch?
    var tlx, dx: CGFloat?
    var tly, dy: CGFloat?
    var yzero: CGFloat = 0
    var xzero: CGFloat = 0
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    let enemyMovement = [CGVector(dx: -200, dy: 0), CGVector(dx: 200, dy: 0), CGVector(dx: 0, dy: 200), CGVector(dx: 0, dy: -200)]
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    var player, enemy : SKSpriteNode?
    
    @objc func enemyMoves () {
        //for i in 0..<enemies.count {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval((arc4random_uniform(10)+1)/10), target: self, selector: #selector(enemyMoves), userInfo: nil, repeats: false)
        if i < enemies.count {
            enemies[i].physicsBody?.velocity = enemyMovement[Int(arc4random_uniform(4))]
            i += 1
        } else {
            i = 0
        }
    }
    
    func spawnEnemy () {
        enemy = SKSpriteNode(imageNamed: "Tturret")
        enemy?.position = CGPoint (x: 0, y: 500)
        enemy?.physicsBody = SKPhysicsBody(texture: (enemy?.texture)!, size: (enemy?.texture?.size())!)
        enemy?.physicsBody?.affectedByGravity = false
        enemy?.physicsBody?.linearDamping = 0
        //enemy?.physicsBody?.allowsRotation = false
        self.addChild(enemy!)
        enemies.append(enemy!)
    }
    
    override func didMove(to view: SKView) {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(arc4random_uniform(3)+1), target: self, selector: #selector(enemyMoves), userInfo: nil, repeats: false)
        player = childNode(withName: "TankPlayer") as? SKSpriteNode
        for _ in 1...4 {
            spawnEnemy()
        }
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
