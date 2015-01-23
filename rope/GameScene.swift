//
//  GameScene.swift
//  rope
//
//  Created by wangbo on 1/23/15.
//  Copyright (c) 2015 wangbo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    // two ends of rope
    var player : SKSpriteNode
    var anchor : SKSpriteNode
    
    required init?(coder aDecoder: NSCoder)  {
        player = SKSpriteNode()
        anchor = SKSpriteNode()
        
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        // 1.set border
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        //2.set end rope node
        self.anchor = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 30, height: 30))
        self.anchor.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height - anchor.size.height)
        self.anchor.physicsBody = SKPhysicsBody(rectangleOfSize: anchor.frame.size)
        self.anchor.physicsBody?.dynamic = false
        self.anchor.physicsBody?.collisionBitMask = 1
        self.anchor.physicsBody?.categoryBitMask = 1
        self.anchor.physicsBody?.contactTestBitMask = 1
        self.addChild(self.anchor)
        
        //3.set start rope node
        self.player = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 50, height: 50))
        self.player.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.player.physicsBody = SKPhysicsBody(rectangleOfSize: player.frame.size)
        self.player.physicsBody?.collisionBitMask = 1
        self.player.physicsBody?.categoryBitMask = 1
        self.player.physicsBody?.contactTestBitMask = 1
        self.addChild(self.player)
        
        //4.set Rope
        var rope = Rope(parentScene: self, node: self.player, node: self.anchor)
        
        //5.set label
        var label = SKLabelNode(text: "Tap on screen to move block")
        label.fontColor = UIColor.blackColor()
        label.position = CGPoint(x: self.frame.size.width / 2, y: 200)
        self.addChild(label)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            var location = touch.locationInNode(self)
            
            // 1. remove previous rope nodes
            self.enumerateChildNodesWithName("rope", usingBlock: { node, stop in
                node.removeFromParent()
            })
            
            // 2. set new end point
            self.player.position = location
            self.player.zRotation = 0.0
            self.player.physicsBody?.velocity = CGVectorMake(0.0, 0.0);
            
            // 3.set new rope
            var rope = Rope(parentScene: self, node: self.player, node: self.anchor)
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
