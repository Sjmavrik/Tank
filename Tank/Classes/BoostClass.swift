//
//  BoostClass.swift
//  Tank
//
//  Created by Артем Тюменцев on 23.11.2017.
//  Copyright © 2017 Артем Тюменцев. All rights reserved.
//

import SpriteKit

class BoostClass: SKSpriteNode {
    var random: UInt32
    var timer = Timer()
    init() {
        random = arc4random_uniform(3)
        let boost = SKTexture (imageNamed: "up")
        super.init(texture: boost, color: UIColor.clear, size: CGSize(width: 180, height: 180))
        switch random {
        case 0:
            texture = SKTexture (imageNamed: "up")
        case 1:
            texture = SKTexture (imageNamed: "down")
        case 2:
            texture = SKTexture (imageNamed: "left")
        case 3:
            texture = SKTexture (imageNamed: "right")
        default:
            break
        }
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody?.affectedByGravity = false
        physicsBody?.usesPreciseCollisionDetection = false
        physicsBody?.restitution = 0
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = (currentScene?.BoostCategory)!
        physicsBody?.contactTestBitMask = (currentScene?.PlayerCategory)!
        position = CGPoint (x: 0, y: -515)
        currentScene?.addChild(self)
        
    }
    func applyBoost () {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(removeBoost), userInfo: nil, repeats: false)
        currentScene?.player.velocityMultiplier = 5
        removeFromParent()
    }
    //Удаление буста
    @objc func removeBoost() {
        currentScene?.player.velocityMultiplier = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
