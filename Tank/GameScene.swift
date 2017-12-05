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
    let BoostCategory : UInt32 = 0x1 << 5
    var i = 0
    var moving: Bool = false
    var shooting: Bool = false
    var touch, touchR: UITouch?
    var yzero: CGFloat = 0
    var xzero: CGFloat = 0
    var player : Player!
    var tileMap : SKTileMapNode!
    
    private var lastUpdateTime : TimeInterval = 0
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    
    
    override func didMove(to view: SKView) {
        
        player = Player ()
        hpBar.text = "HP = \(player.hp)"
        let _ = Eagle ()
        let _ = BoostClass ()
        player.position = CGPoint (x: -300, y: -929)
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
        
        player.timerRepeatFire.invalidate()

        for child in children {
            (child as? Enemy)?.moveTimer.invalidate()
            (child as? Enemy)?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        run(SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction.run({self.view?.presentScene(MenuScene(fileNamed: "SceneGameOver"))})]))
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
                player.playerVelocityVector = CGVector(dx: 200*player.velocityMultiplier, dy: 0)
            } else if tlx! < xzero && abs(dx) - abs(dy) > 50 {
                player.zRotation = 90 * CGFloat.pi / 180
                player.playerVelocityVector = CGVector(dx: -200*player.velocityMultiplier, dy: 0)
            } else if tly! > yzero && abs(dy) - abs(dx) > 50 {
                player.zRotation = 0 * CGFloat.pi / 180
                player.playerVelocityVector = CGVector(dx: 0, dy: 200*player.velocityMultiplier)
            } else if tly! < yzero && abs(dy) - abs(dx) > 50 {
                player.zRotation = 180 * CGFloat.pi / 180
                player.playerVelocityVector = CGVector(dx: 0, dy: -200*player.velocityMultiplier)
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
        if firstBody.categoryBitMask == PlayerCategory && secondBody.categoryBitMask == BoostCategory {
            (secondBody.node as! BoostClass).applyBoost()
        }
        if (firstBody.categoryBitMask == EnemyBulletCategory || firstBody.categoryBitMask == BulletCategory) && secondBody.categoryBitMask == EagleCategory {
            (firstBody.node as? Bullet)?.destroy()
            (firstBody.node as? EnemyBullet)?.destroy()
            gameOver()
        }
        
    }
    func tileSetProcessing() {
        tileMap = childNode(withName: "LevelMap") as! SKTileMapNode
        
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                let isEdgeTile = tileDefinition?.userData?["edgeTile"] as? Bool
                if (isEdgeTile ?? false) {
                    let x = CGFloat(col) * tileSize.width - halfWidth
                    let y = CGFloat(row) * tileSize.height - halfHeight
                    let rect = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
                    let tileNode = SKShapeNode(rect: rect)
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0))
                    tileNode.physicsBody?.isDynamic = false
                    tileNode.physicsBody?.collisionBitMask = playerCollisionMask | wallCollisionMask
                    tileNode.physicsBody?.categoryBitMask = wallCollisionMask
                    tileMap.addChild(tileNode)
                }
            }
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
            view?.presentScene(MenuScene(fileNamed: "SceneLevelComplete"))
        }
    }
}

