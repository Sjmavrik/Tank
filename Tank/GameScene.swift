//  wewew
//  GameScene.swift
//  Tank
//
//  Created by Артем Тюменцев on 24.10.17.
//  Copyright © 2017 Артем Тюменцев. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let PlayerCategory   : UInt32 = 0x1 << 0
    let BulletCategory : UInt32 = 0x1 << 1
    let EnemyCategory  : UInt32 = 0x1 << 2
    let EnemyBulletCategory : UInt32 = 0x1 << 3
    let EagleCategory : UInt32 = 0x1 << 4
    var i = 0
    var moving: Bool = false
    var shooting: Bool = false
    var touch, touchR: UITouch?
    var yzero: CGFloat = 0
    var xzero: CGFloat = 0
    var player : Player!
//    var player: SKSpriteNode?
    
    private var lastUpdateTime : TimeInterval = 0
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    
    
    override func didMove(to view: SKView) {
//        player = childNode(withName: "TankPlayer") as? SKSpriteNode
//        player?.physicsBody?.categoryBitMask = PlayerCategory
//        player?.physicsBody?.collisionBitMask = EnemyCategory
        player = Player ()
        let _ = Eagle ()
        player.position = CGPoint (x: -100, y: -815)
        for i in 0...2 {
            spawnEnemy(i)
        }
    }
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.restitution = 0
        currentScene = self as GameScene
        scaleMode = .aspectFit
    }
    
    func spawnEnemy(_ i: Int) {
        let enemy = Enemy(from: "VTank")
        enemy.spawn(at: i)
    }
    
    func gameOver() {
       view?.presentScene(SKScene(fileNamed: "SceneGameOver"))
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
                player.shoot()
                
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
                player.zRotation = -90 * CGFloat.pi / 180
                player.playerVelocityVector = CGVector(dx: 200, dy: 0)
            } else if tlx! < xzero && abs(dx) - abs(dy) > 50 {
                player.zRotation = 90 * CGFloat.pi / 180
                player.playerVelocityVector = CGVector(dx: -200, dy: 0)
            } else if tly! > yzero && abs(dy) - abs(dx) > 50 {
                player.zRotation = 0 * CGFloat.pi / 180
                player.playerVelocityVector = CGVector(dx: 0, dy: 200)
            } else if tly! < yzero && abs(dy) - abs(dx) > 50 {
                player.zRotation = 180 * CGFloat.pi / 180
                player.playerVelocityVector = CGVector(dx: 0, dy: -200)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touch == touches.first {
            moving = false
            player.playerVelocityVector = CGVector (dx: 0, dy: 0)
        } else if touchR == touches.first {
            shooting = false
            player.timerRepeatFire.invalidate()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            moving = false
            player.playerVelocityVector = CGVector (dx: 0, dy: 0)
            shooting = false
            player.timerRepeatFire.invalidate()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if firstBody.categoryBitMask == BulletCategory && secondBody.categoryBitMask == EnemyCategory {
            (firstBody.node as! Bullet).destroy()
            (secondBody.node as! Enemy).destroy()
        }
        if firstBody.categoryBitMask == BulletCategory && secondBody.categoryBitMask == EnemyBulletCategory {
            (firstBody.node as! Bullet).destroy()
            (secondBody.node as! EnemyBullet).destroy()
        }
        if firstBody.categoryBitMask == PlayerCategory && secondBody.categoryBitMask == EnemyBulletCategory {
            //(firstBody.node as! Bullet).destroy()
            (secondBody.node as! EnemyBullet).destroy()
        }
        if firstBody.categoryBitMask == EnemyCategory && secondBody.categoryBitMask == EnemyBulletCategory {
            (secondBody.node as! EnemyBullet).destroy()
        }
        if firstBody.categoryBitMask == EnemyBulletCategory && secondBody.categoryBitMask == EnemyBulletCategory {
            (firstBody.node as! EnemyBullet).destroy()
            (secondBody.node as! EnemyBullet).destroy()
        }
        if firstBody.categoryBitMask == PlayerCategory && secondBody.categoryBitMask == EnemyBulletCategory {
            (firstBody.node as! Player).destroy()
            (secondBody.node as! EnemyBullet).destroy()
        }
        if firstBody.categoryBitMask == EnemyBulletCategory && secondBody.categoryBitMask == EagleCategory {
//            (firstBody.node as! EnemyBullet).destroy()
            gameOver()
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
        
        player.physicsBody?.velocity = player.playerVelocityVector
        
        //scene change
        
        var enemies = [Enemy]()
        for child in children {
            if child is Enemy {
                 enemies.append(child as! Enemy)
                 (child as! Enemy).updateMovement()
            }
        }
        if enemies.count == 0 {
            player.timerRepeatFire.invalidate()
            view?.presentScene(GameScene(fileNamed: "GameScene2"))
        }
    }
}

