//
//  PlayerClass.swift
//  Tank
//
//  Created by Артем Тюменцев on 13.11.17.
//  Copyright © 2017 Артем Тюменцев. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var hp = 2
    var timer = Timer ()
    var timerRepeatFire = Timer()
    var playerVelocityVector = CGVector ()
    var velocityMultiplier = 1
    
    init() {
        let texture = SKTexture (imageNamed: "TTank")
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 140, height: 180))
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 0
        physicsBody?.allowsRotation = false
        physicsBody?.usesPreciseCollisionDetection = false
        physicsBody?.restitution = 0
        physicsBody?.categoryBitMask = (currentScene?.PlayerCategory)!
        physicsBody?.collisionBitMask = (currentScene?.PlayerCategory)! | (currentScene?.EnemyCategory)! | (currentScene?.EagleCategory)! | (currentScene?.SteelCategory)!
        physicsBody?.contactTestBitMask = (currentScene?.EnemyBulletCategory)!
        currentScene?.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func shoot() {
        timerRepeatFire = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(shoot), userInfo: nil, repeats: false)
        _ = Bullet(at: (self.position), with: (self.zRotation))
    }
    func destroy() {
        hp -= 1
        print("\(hp)")
        hpBar.text = ("HP = \(hp)")
        if hp <= 0 {
           currentScene?.gameOver()
        }
    }
}
// Пулька игрока
class Bullet: SKSpriteNode {
    
    init(at position: CGPoint, with rotation: CGFloat) {
        super.init(texture: SKTexture(imageNamed: "Bullet"), color: UIColor.clear, size: SKTexture(imageNamed: "Bullet").size())
        self.zRotation = rotation
        self.position = CGPoint(x: position.x - 50*sin(self.zRotation), y: position.y + 50*cos(self.zRotation))
        self.setScale(0.08)
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 0
        physicsBody?.allowsRotation = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.restitution = 0
        physicsBody?.collisionBitMask = 0
        physicsBody?.categoryBitMask = (currentScene?.BulletCategory)!
        physicsBody?.contactTestBitMask = (currentScene?.EnemyCategory)! | (currentScene?.EnemyBulletCategory)! | (currentScene?.EagleCategory)!
        currentScene?.addChild(self)
        physicsBody?.velocity = CGVector(dx: -1000*sin(self.zRotation), dy: 1000*cos(self.zRotation))
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(destroy), userInfo: nil, repeats: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func destroy() {
        removeFromParent()
    }
    
}
// Класс Орла
class Eagle: SKSpriteNode {
    init() {
        let eagle = SKTexture (imageNamed: "Tturret")
        super.init(texture: eagle, color: UIColor.clear, size: CGSize(width: 180, height: 180))
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody?.affectedByGravity = false
        physicsBody?.usesPreciseCollisionDetection = false
        physicsBody?.restitution = 0
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = (currentScene?.EagleCategory)!
        physicsBody?.contactTestBitMask = (currentScene?.EnemyBulletCategory)! | (currentScene?.BulletCategory)!
        position = CGPoint (x: 0, y: -929)
        currentScene?.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


