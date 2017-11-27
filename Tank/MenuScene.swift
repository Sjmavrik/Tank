//
//  MenuScene.swift
//  Tank
//
//  Created by Марк Трясцин on 16.11.17.
//  Copyright © 2017 Артем Тюменцев. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var start : SKLabelNode?
    
    override func sceneDidLoad() {
        scaleMode = .aspectFit
        start = childNode(withName: "RESTART") as? SKLabelNode
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (start?.contains((touches.first?.location(in: self))!))! {
           view?.presentScene(GameScene(fileNamed: "GameScene"))
        }
    }
}
