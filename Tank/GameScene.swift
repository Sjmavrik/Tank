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
    var moveTimer = Timer()
    var fireTimer = Timer()
    var timerRepeatFire = Timer()
    var enemies = [SKSpriteNode]()
    var moving: Bool = false
    var shooting: Bool = false
    var touch, touchR: UITouch?
    var yzero: CGFloat = 0
    var xzero: CGFloat = 0
    let enemyMovement = [CGVector(dx: -200, dy: 0),
                         CGVector(dx: 200, dy: 0),
                         CGVector(dx: 0, dy: 200),
                         CGVector(dx: 0, dy: -200)]
    var player, enemy : SKSpriteNode?

    private var lastUpdateTime : TimeInterval = 0
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    @objc func enemyMoves() {
        moveTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(enemyMoves), userInfo: nil, repeats: false)
        for i in 0..<enemies.count {
            let j = Int(arc4random_uniform(3))
            if j == 0 {
                let r = Int(arc4random_uniform(4))
                enemies[i].physicsBody?.velocity = enemyMovement[r]
                if r == 0 {enemies[i].run(SKAction.rotate(toAngle: 0 * CGFloat.pi / 180, duration: 0.1, shortestUnitArc: true))}
                if r == 1 {enemies[i].run(SKAction.rotate(toAngle: 180 * CGFloat.pi / 180, duration: 0.1, shortestUnitArc: true))}
                if r == 2 {enemies[i].run(SKAction.rotate(toAngle: 270 * CGFloat.pi / 180, duration: 0.1, shortestUnitArc: true))}
                if r == 3 {enemies[i].run(SKAction.rotate(toAngle: 90 * CGFloat.pi / 180, duration: 0.1, shortestUnitArc: true))}
            }
        }
    }
    
    func enemyShoots() {
        //HERE
    }
    
    @objc func shoot() {
        print("didShoot \(i)")
        i+=1
        timerRepeatFire = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(shoot), userInfo: nil, repeats: false)
    }
    
    func spawnEnemy(_ i: Int) {
        enemy = SKSpriteNode(imageNamed: "Tturret")
        enemy?.position = CGPoint (x: i*200, y: 500)
        enemy?.physicsBody = SKPhysicsBody(rectangleOf: (enemy?.texture?.size())!)
        enemy?.physicsBody?.affectedByGravity = false
        enemy?.physicsBody?.linearDamping = 0
        enemy?.physicsBody?.allowsRotation = false
        enemy?.physicsBody?.usesPreciseCollisionDetection = true
        enemy?.physicsBody?.restitution = 0
        self.addChild(enemy!)
        enemies.append(enemy!)
    }
    
    override func didMove(to view: SKView) {
        moveTimer = Timer.scheduledTimer(timeInterval: TimeInterval(arc4random_uniform(3)+1), target: self, selector: #selector(enemyMoves), userInfo: nil, repeats: false)
        player = childNode(withName: "TankPlayer") as? SKSpriteNode
        for i in 1...4 {
            spawnEnemy(i)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
                player?.physicsBody?.velocity = CGVector(dx: 200, dy: 0)
            } else if tlx! < xzero && abs(dx) - abs(dy) > 50 {
                player?.zRotation = 0 * CGFloat.pi / 180
                player?.physicsBody?.velocity = CGVector(dx: -200, dy: 0)
            } else if tly! > yzero && abs(dy) - abs(dx) > 50 {
                player?.zRotation = 270 * CGFloat.pi / 180
                player?.physicsBody?.velocity = CGVector(dx: 0, dy: 200)
            } else if tly! < yzero && abs(dy) - abs(dx) > 50 {
                player?.zRotation = 90 * CGFloat.pi / 180
                player?.physicsBody?.velocity = CGVector(dx: 0, dy: -200)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touch == touches.first {
            moving = false
            player?.physicsBody?.velocity = CGVector (dx: 0, dy: 0)
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
    }
}
