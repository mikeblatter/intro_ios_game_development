import SpriteKit
import PlaygroundSupport

let width = 480
let height = 640
let worldGravity: Float = 5
let numberOfSatelites = 10

class Scene: SKScene {
    func createWorld() -> SKSpriteNode {
        let node = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 50, height: 50))
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody!.isDynamic = false
        node.position = CGPoint(x: 0.5 * super.size.width, y: 0.5 * super.size.height)
        
        // Add gravity
        let gravity = SKFieldNode.radialGravityField()
        gravity.strength = worldGravity
        node.addChild(gravity)
        
        return node
    }
    
    func createSatelite() -> SKSpriteNode {
        let node = SKSpriteNode(color: SKColor.white, size: CGSize(width: 10, height: 10))
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        
        node.physicsBody!.mass = 5
        node.physicsBody!.affectedByGravity = true
    
        node.position = CGPoint(x: CGFloat.random(in: -size.width/2...size.width/2), y: CGFloat.random(in: -size.height/2...size.height/2))
        node.physicsBody!.velocity = CGVector(dx: -5, dy: 200)
        return node
    }
    
    // Lifecycle func when we can start adding to the scene
    override func didMove(to view: SKView) {
        super.size = CGSize(width: width, height: height)
                
        super.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        addChild(createWorld())
        
        for _ in 0...numberOfSatelites {
            addChild(createSatelite())
        }
    }
}

let scene = Scene()
scene.scaleMode = .aspectFit

let view = SKView(frame: CGRect(x: 0, y: 0, width: width, height: height))
view.presentScene(scene)
PlaygroundPage.current.liveView = view
