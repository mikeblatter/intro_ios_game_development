import SpriteKit
import PlaygroundSupport

class Scene: SKScene, SKPhysicsContactDelegate {
    let blockMargin: CGFloat = 10
    let blockWidth: CGFloat = 150
    let blockHeight: CGFloat = 50
    let rows = 3
    let columns = 11
    let numberOfBalls = 2
    
    struct CategoryBitMask {
        static let Ball: UInt32 = 0b1 << 0
        static let Block: UInt32 = 0b1 << 2
    }
    
    func createBall() -> SKSpriteNode {
        let ball = SKSpriteNode(color: SKColor.white, size: CGSize(width: 50, height: 50))
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody!.allowsRotation = false
        ball.physicsBody!.categoryBitMask = CategoryBitMask.Ball
        ball.physicsBody!.contactTestBitMask = CategoryBitMask.Block | CategoryBitMask.Ball
        ball.physicsBody!.friction = 0
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.velocity = CGVector(dx: 1000, dy: 1000)
        ball.position = CGPoint(x: 0.5 * super.size.width, y: 0.5 * super.size.height)
        return ball
    }
    
    func createBlock(x: Int, y: Int) -> SKSpriteNode {
        let block = SKSpriteNode(color: SKColor.white, size: CGSize(width: blockWidth, height: blockHeight))
        block.name = "Block"
        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
        block.physicsBody!.categoryBitMask = CategoryBitMask.Block
        block.physicsBody!.isDynamic = false
        block.physicsBody!.friction = 0
        block.physicsBody!.restitution = 1
        
        block.position = CGPoint(x: (block.size.width + blockMargin) * CGFloat(x), y: (block.size.height + blockMargin) * CGFloat(y))
        
        return block
    }
    
    override func didMove(to view: SKView) {
        super.size = CGSize(width: 1920, height: 1080)
        
        super.physicsWorld.contactDelegate = self
        
        super.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        let sceneBound = SKPhysicsBody(edgeLoopFrom: super.frame)
        sceneBound.friction = 0
        sceneBound.restitution = 1
        super.physicsBody = sceneBound
        
        for _ in 1...numberOfBalls {
            super.addChild(createBall())
        }

        for y in 1...rows {
            for x in 1...columns {
                super.addChild(createBlock(x: x, y: y))
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == CategoryBitMask.Ball &&
            contact.bodyB.categoryBitMask == CategoryBitMask.Block {
            let block = contact.bodyB.node as! SKSpriteNode
            
            if block.name == "Block" {
                block.color = SKColor.darkGray
                block.name = "HalfBlock"
            }
            else {
                block.removeFromParent()
            }
        }
    }
}

let scene = Scene()
scene.scaleMode = .aspectFit

let view = SKView(frame: NSRect(x: 0, y: 0, width: 640, height: 360))
view.presentScene(scene)
PlaygroundPage.current.liveView = view
