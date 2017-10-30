//
//  Classes.swift
//  Tank
//
//  Created by Марк Трясцин on 28.10.17.
//  Copyright © 2017 Артем Тюменцев. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    var r = Int()
    var moveTimer = Timer()
    var fireTimer = Timer()
    let enemyMovement = [CGVector(dx: -200, dy: 0),
                         CGVector(dx: 200, dy: 0),
                         CGVector(dx: 0, dy: 200),
                         CGVector(dx: 0, dy: -200)]
    let enemySpawnPosition = [CGPoint(x: -800, y: 800),
                              CGPoint(x: 0, y: 800),
                              CGPoint(x: 800, y: 800)]
    
    init(from textureName: String) {
        let texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        physicsBody = SKPhysicsBody(rectangleOf: texture.size())
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 0
        physicsBody?.allowsRotation = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.restitution = 0
        isUserInteractionEnabled = true
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
        currentScene.addChild(self)
    }
    
    @objc func movementDirection() {
        moveTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(movementDirection), userInfo: nil, repeats: false)
        let j = Int(arc4random_uniform(3))
        if j == 0 {
            r = Int(arc4random_uniform(4))
            if r == 0 {run(SKAction.rotate(toAngle: 0 * CGFloat.pi / 180, duration: 0.1, shortestUnitArc: true))}
            if r == 1 {run(SKAction.rotate(toAngle: 180 * CGFloat.pi / 180, duration: 0.1, shortestUnitArc: true))}
            if r == 2 {run(SKAction.rotate(toAngle: 270 * CGFloat.pi / 180, duration: 0.1, shortestUnitArc: true))}
            if r == 3 {run(SKAction.rotate(toAngle: 90 * CGFloat.pi / 180, duration: 0.1, shortestUnitArc: true))}
        }
    }
    
    func shoot() {
        
    }
    
    func destroy() {
        removeFromParent()
        moveTimer.invalidate()
    }
    
    func updateMovement() {
        physicsBody?.velocity = enemyMovement[r]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        destroy()
    }
    
}
