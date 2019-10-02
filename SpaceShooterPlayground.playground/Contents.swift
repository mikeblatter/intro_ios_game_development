//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

let width: CGFloat = 480
let height: CGFloat = 640
let numberOfAsteroids = 1
let lowerBoundAsteroidSpeed: CGFloat = 10000
let upperBoundAsteroidSpeed: CGFloat = 20000

struct CategoryBitMask {
    static let Background: UInt32 = 0b1 << 0
    static let Player: UInt32 = 0b1 << 1
    static let Asteroid: UInt32 = 0b1 << 2
    static let Laser: UInt32 = 0b1 << 2
}

struct ContactBitMask {
    static let Background = CategoryBitMask.Asteroid | CategoryBitMask.Laser
    static let Player = CategoryBitMask.Asteroid
    static let Asteroid = CategoryBitMask.Asteroid | CategoryBitMask.Background | CategoryBitMask.Laser
    static let Laser = CategoryBitMask.Asteroid | CategoryBitMask.Background
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMove(to view: SKView) {
        // Initialize lifecycle hook, add stuff to scene here
        super.size = CGSize(width: width, height: height)
        super.physicsWorld.contactDelegate = self
        
        super.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        let sceneBound = SKPhysicsBody(edgeLoopFrom: super.frame)
        sceneBound.friction = 0
        sceneBound.restitution = 1
        super.physicsBody = sceneBound
        
        name = UUID().uuidString
        physicsBody?.categoryBitMask = CategoryBitMask.Background
        physicsBody?.contactTestBitMask = ContactBitMask.Background
        
        createPlayer()
        
        for _ in 0...numberOfAsteroids {
            createAsteroid()
        }
    }
    
    func createAsteroid() {
        let texture = SKTexture(imageNamed: "Asteroid")
        
        let asteroidSize = CGFloat.random(in: 25...100)
        let onXorY = Bool.random()
        let xPosition: CGFloat, yPosition: CGFloat
        
        if onXorY {
            // random on x
            xPosition = CGFloat.random(in: -size.width/2 + asteroidSize...size.width/2 - asteroidSize)
            yPosition = -size.height/2 + asteroidSize
        }
        else {
            // random on y
            xPosition = -size.width/2 + asteroidSize
            yPosition = CGFloat.random(in: -size.height/2 + asteroidSize...size.height/2 - asteroidSize)
        }

        let spriteSize = CGSize(width: asteroidSize, height: asteroidSize)
        let spriteNode = SKSpriteNode(texture: texture, size: spriteSize)
        spriteNode.name = UUID().uuidString
        spriteNode.position = CGPoint(x: xPosition, y: yPosition)

        spriteNode.physicsBody = SKPhysicsBody(circleOfRadius: max(size.width / 2, size.height / 2))
        spriteNode.physicsBody?.affectedByGravity = false
        
        let dxPositive = Bool.random()
        let dyPositive = Bool.random()
        let dx = (dxPositive) ? getRandomAsteroidSpeed() : getRandomAsteroidSpeed() * -1
        let dy = (dyPositive) ? getRandomAsteroidSpeed() : getRandomAsteroidSpeed() * -1
        
        spriteNode.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
        spriteNode.physicsBody?.friction = 0
        spriteNode.physicsBody?.linearDamping = 0
        spriteNode.physicsBody?.affectedByGravity = false
        
        spriteNode.physicsBody?.categoryBitMask = CategoryBitMask.Asteroid
        spriteNode.physicsBody?.contactTestBitMask = ContactBitMask.Asteroid
        
        addChild(spriteNode)
    }
    
    func getRandomAsteroidSpeed() -> CGFloat {
        return CGFloat.random(in: lowerBoundAsteroidSpeed...lowerBoundAsteroidSpeed)
    }
    
    func createLaser() {
        let texture = SKTexture(imageNamed: "Laser")
        let spriteSize = CGSize(width: 10, height: 10)
        let spriteNode = SKSpriteNode(texture: texture, size: spriteSize)
        spriteNode.position = CGPoint(x: 0, y: 0)
        spriteNode.name = UUID().uuidString

        spriteNode.physicsBody = SKPhysicsBody(circleOfRadius: max(size.width / 2, size.height / 2))
        spriteNode.physicsBody?.affectedByGravity = false
        spriteNode.physicsBody?.isDynamic = false
        spriteNode.physicsBody?.pinned = true
        
        spriteNode.physicsBody?.categoryBitMask = CategoryBitMask.Laser
        spriteNode.physicsBody?.contactTestBitMask = ContactBitMask.Laser
        
        addChild(spriteNode)
    }
    
    func createPlayer() {
        let texture = SKTexture(imageNamed: "Player")
        let spriteSize = CGSize(width: 30, height: 30)
        let spriteNode = SKSpriteNode(texture: texture, size: spriteSize)
        spriteNode.position = CGPoint(x: 0, y: 0)
        spriteNode.name = UUID().uuidString

        spriteNode.physicsBody = SKPhysicsBody(circleOfRadius: max(size.width / 2, size.height / 2))
        spriteNode.physicsBody?.affectedByGravity = false
        spriteNode.physicsBody?.isDynamic = false
        spriteNode.physicsBody?.pinned = true
        
        spriteNode.physicsBody?.categoryBitMask = CategoryBitMask.Player
        spriteNode.physicsBody?.contactTestBitMask = ContactBitMask.Player
        
        addChild(spriteNode)
    }
    
    @objc static override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: width, height: height))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
