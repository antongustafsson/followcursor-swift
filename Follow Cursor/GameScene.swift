//
//  GameScene.swift
//  Follow Cursor
//
//  Created by Anton Gustafsson on 2017-05-12.
//  Copyright © 2017 Anton Gustafsson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, GKAgentDelegate {
    
    var lastUpdateTime: TimeInterval = 0
    
    var playerAgent = GKAgent2D()
    var targetAgent = GKAgent2D()
    
    var playerNode = SKNode()
    var obstacleNode = SKNode()
    
    var seekGoal = GKGoal()
    var avoidGoal = GKGoal()
    var speedGoal = GKGoal()
    
    override func didMove(to view: SKView) {
        print("didMove to view")
        playerAgent.delegate = self
        
        let options = [NSTrackingAreaOptions.mouseMoved, NSTrackingAreaOptions.activeInKeyWindow, NSTrackingAreaOptions.activeAlways, NSTrackingAreaOptions.inVisibleRect, ] as NSTrackingAreaOptions
        let tracker = NSTrackingArea(rect:frame, options: options, owner: view, userInfo: nil)
        view.addTrackingArea(tracker)
        
        playerNode = (scene?.childNode(withName: "player"))!
        obstacleNode = (scene?.childNode(withName: "obstacle"))!
        var obstacles = SKNode.obstacles(fromNodeBounds: [obstacleNode])
        
        print(CGPoint(
            x: Double(obstacleNode.position.x),
            y: Double(obstacleNode.position.y)
        ))
        
        seekGoal = GKGoal(toSeekAgent: targetAgent)
        avoidGoal = GKGoal(toAvoid: obstacles, maxPredictionTime: 10000.0)
        speedGoal = GKGoal(toReachTargetSpeed: 4.0)
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        print(playerAgent.position)
        print(vector_float2(Float(playerNode.position.x), Float(playerNode.position.y)))
        playerAgent.position = vector_float2(Float(playerNode.position.x), Float(playerNode.position.y))
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        playerNode.physicsBody?.velocity = CGVector(dx: CGFloat(playerAgent.velocity.x), dy: CGFloat(playerAgent.velocity.y))
//        let distance = distanceBetween(point1: CGPoint(x: CGFloat(targetAgent.position.x), y: CGFloat(targetAgent.position.y)), point2: CGPoint(x: CGFloat(playerAgent.position.x), y: CGFloat(playerAgent.position.y)))
//        if distance < 200 {
//            playerAgent.behavior?.setWeight(0.0, for: seekGoal)
//        }else{
//            playerAgent.behavior?.setWeight(2.0, for: seekGoal)
//        }
//        print("Distance:", distance)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        print("Touch down, at: \(pos)")
        
        
        playerAgent.radius = Float(playerNode.frame.width)
        playerAgent.mass = 0.01
        playerAgent.maxSpeed = 400
        print(playerNode.frame.width)
        
        targetAgent.position.x = Float(pos.x)
        targetAgent.position.y = Float(pos.y)
        
        

        let behaviour = GKBehavior()
        behaviour.setWeight(1.0, for: speedGoal)
        behaviour.setWeight(2.0, for: seekGoal)
        behaviour.setWeight(30.0, for: avoidGoal)
//        behaviour.setWeight(2.0, for: fleeGoal)
        
        playerAgent.behavior = behaviour
    }
    
    func distanceBetween(point1: CGPoint, point2: CGPoint) -> CGFloat{
        let deltaX = point2.x - point1.x
        let deltaY = point2.y - point1.y
        return sqrt(pow(deltaX, 2) + pow(deltaY, 2))
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    func mouseMoved(toPoint pos : CGPoint){
        targetAgent.position.x = Float(pos.x)
        targetAgent.position.y = Float(pos.y)
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseMoved(with event: NSEvent) {
        self.mouseMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            
        break
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let deltaTime = currentTime - lastUpdateTime
        playerAgent.update(deltaTime: deltaTime)
        lastUpdateTime = currentTime
    }
}
