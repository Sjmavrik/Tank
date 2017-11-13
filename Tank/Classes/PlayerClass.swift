//
//  PlayerClass.swift
//  Tank
//
//  Created by Артем Тюменцев on 13.11.17.
//  Copyright © 2017 Артем Тюменцев. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var hp = 20
    var timer = Timer ()
    var playerVelocityVector = CGVector ()
    
    init() {
        let texture = SKTexture (imageNamed: "TTank")
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 140, height: 180))
       /* physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 140, height: 180))
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 0
        physicsBody?.allowsRotation = false
        physicsBody?.usesPreciseCollisionDetection = false
        physicsBody?.restitution = 0
        physicsBody?.categoryBitMask = (currentScene?.EnemyCategory)!
        physicsBody?.collisionBitMask = (currentScene?.PlayerCategory)! | (currentScene?.EnemyCategory)!
        physicsBody?.contactTestBitMask = (currentScene?.BulletCategory)!*/
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

