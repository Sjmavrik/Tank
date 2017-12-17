//
//  Classes.swift
//  Tank
//
//  Created by Марк Трясцин on 28.10.17.
//  Copyright © 2017 Артем Тюменцев. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    var hp = 1
    var r = Int()
    var moveTimer = Timer()
    var fireTimer = Timer()
    var enemyVelocityVector = CGVector()
    let enemyMovement = [CGVector(dx: -200, dy: 0),
                         CGVector(dx: 200, dy: 0),
                         CGVector(dx: 0, dy: 200),
                         CGVector(dx: 0, dy: -200)]
    let enemySpawnPosition = [CGPoint(x: -800, y: 800),
                              CGPoint(x: 0, y: 800),
                              CGPoint(x: 800, y: 800)]
    
    init(from textureName: String) {
        let texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: UIColor.clear, size: CGSize (width: 140, height: 180))
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 0
        physicsBody?.allowsRotation = false
        physicsBody?.usesPreciseCollisionDetection = false
        physicsBody?.restitution = 0
        physicsBody?.categoryBitMask = (currentScene?.EnemyCategory)!
        physicsBody?.collisionBitMask = (currentScene?.PlayerCategory)! | (currentScene?.EnemyCategory)! | (currentScene?.SteelCategory)!
        physicsBody?.contactTestBitMask = (currentScene?.BulletCategory)!
        moveTimer = Timer.scheduledTimer(timeInterval: TimeInterval(arc4random_uniform(3)+1), target: self, selector: #selector(movementDirection), userInfo: nil, repeats: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("tank destroyed")
    }
    
    func spawn(at position: Int) {
        self.position = enemySpawnPosition[position]
        currentScene?.addChild(self)
    }
    
    @objc func movementDirection() {
        moveTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(movementDirection), userInfo: nil, repeats: false)
        let j = Int(arc4random_uniform(3))
        if j == 0 {
            r = Int(arc4random_uniform(4))
            if r == 3 {self.zRotation = 90 * CGFloat.pi / 180
                enemyVelocityVector = CGVector(dx: -200, dy: 0)}
            if r == 2 {self.zRotation = -90 * CGFloat.pi / 180
                enemyVelocityVector = CGVector(dx: 200, dy: 0)}
            if r == 0 {self.zRotation = 0 * CGFloat.pi / 180
                enemyVelocityVector = CGVector(dx: 0, dy: 200)}
            if r == 1 {self.zRotation = 180 * CGFloat.pi / 180
                enemyVelocityVector = CGVector(dx: 0, dy: -200)}
            shoot()
           
        }
    }
    
    func shoot() {
        _ = EnemyBullet(at: self.position, with: self.zRotation)
    }
    
    func destroy() {
        hp -= 1
        if hp <= 0 {
            removeFromParent()
            moveTimer.invalidate()
        }
    }
    
    func updateMovement() {
        physicsBody?.velocity = enemyVelocityVector
    }
    
}
// Пулька Вражины
class EnemyBullet: Bullet {
    override init(at position: CGPoint, with rotation: CGFloat) {
        super.init(at: position, with: rotation)
        self.position = CGPoint(x: position.x - 300*sin(self.zRotation), y: position.y + 300*cos(self.zRotation))
        physicsBody?.categoryBitMask = (currentScene?.EnemyBulletCategory)!
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = (currentScene?.PlayerCategory)! | (currentScene?.BulletCategory)! | (currentScene?.EnemyCategory)! | (currentScene?.EnemyBulletCategory)! | (currentScene?.EagleCategory)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
