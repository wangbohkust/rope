//
//  Rope.swift
//  rope
//
//  Created by wangbo on 1/23/15.
//  Copyright (c) 2015 wangbo. All rights reserved.
//

import SpriteKit

class Rope : SKNode {
    // two end nodes
    var Snode : SKNode
    var Dnode : SKNode
    var parentScene : SKScene
    
    init(parentScene scene : SKScene, node Snode : SKNode, node Dnode : SKNode) {
        
        self.Snode = Snode
        self.Dnode = Dnode
        self.parentScene = scene
        
        super.init()
        self.name = "rope"
        self.createRope()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createRope() {
        // basic length calculation
        var deltaX = Dnode.position.x - Snode.position.x
        var deltaY = Dnode.position.y - (Snode.position.y  + (Snode.frame.size.height / 2))
        var total = deltaX * deltaX + deltaY * deltaY
        var distance = Float(sqrtf(Float(total)))
        var height = Float(SKSpriteNode(imageNamed: "rope.png").size.height - 1.0)       //?
        // nodes number
        var num = (distance / height)
        var points = Int(num)
        points -= 1;
        let vX = CGFloat(deltaX) / CGFloat(points)
        let vY = CGFloat(deltaY) / CGFloat(points)
        var vector = CGPoint(x: vX, y: vY)
        // create temp node & rotate angel
        var previousNode : SKSpriteNode?
        var angle = atan2f(Float(deltaY), Float(deltaX))
        // join nodes
        for i in 0...points {
            var x = self.Snode.position.x
            var y = self.Snode.position.y + (self.Snode.frame.size.height / 2)
            y += vector.y * CGFloat(i)
            x += vector.x * CGFloat(i)
            
            var ropePiece = SKSpriteNode(imageNamed: "rope.png")
            ropePiece.name = "rope"
            ropePiece.position = CGPoint(x: x, y: y)
            ropePiece.zRotation = CGFloat(angle + 1.57)
            ropePiece.zPosition = -1
            ropePiece.physicsBody = SKPhysicsBody(rectangleOfSize: ropePiece.size)
            ropePiece.physicsBody?.collisionBitMask = 2
            ropePiece.physicsBody?.categoryBitMask = 2
            ropePiece.physicsBody?.contactTestBitMask = 2
            self.parentScene.addChild(ropePiece)
            
            if let pNode = previousNode {
                     // add joint pin
                var pin = SKPhysicsJointPin.jointWithBodyA( pNode.physicsBody, bodyB: ropePiece.physicsBody, anchor: CGPoint(x: CGRectGetMidX(ropePiece.frame), y: CGRectGetMidY(ropePiece.frame)))
                     self.parentScene.physicsWorld.addJoint(pin)
            } else {
                if i == 0 {
                     // add joint pin with start node
                     var pin = SKPhysicsJointPin.jointWithBodyA(self.Snode.physicsBody, bodyB: ropePiece.physicsBody, anchor: CGPoint(x: CGRectGetMidX(self.Snode.frame), y: CGRectGetMaxY(self.Snode.frame)))
                     self.parentScene.physicsWorld.addJoint(pin)
                }
            }
            previousNode = ropePiece
        }
        // add joint pin with end node
        if let pNode = previousNode {
            var pin = SKPhysicsJointPin.jointWithBodyA(self.Dnode.physicsBody, bodyB: pNode.physicsBody, anchor: CGPoint(x: CGRectGetMidX(pNode.frame), y: CGRectGetMidY(pNode.frame)))
            self.parentScene.physicsWorld.addJoint(pin)
        }
    }
    
    func destroyRope() {
        self.parentScene.enumerateChildNodesWithName("rope", usingBlock: { nodeFound, selectedNode in
            nodeFound.removeFromParent()
        })
    }
}
