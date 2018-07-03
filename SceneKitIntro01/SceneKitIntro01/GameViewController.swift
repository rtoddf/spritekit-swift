import UIKit
import SceneKit

class GameViewController: UIViewController {
    var scnView:SCNView!
    var scnScene:SCNScene!
    var cameraNode:SCNNode!
    var spawnTime:TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        
        setupView()
        setupScene()
        setupCamera()
//        spawnShape()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView() {
        scnView = self.view as! SCNView
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.delegate = self
        // so scenekit doesn't enter a paused state
        scnView.isPlaying = true
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
//        scnScene.background.contents = "courseArt.scnassets/background.png"
    }
    
    func setupCamera() {
        let screensize:CGRect = UIScreen.main.bounds
        let screenHeight = screensize.height
        let newCameraYPosition = Float(screenHeight) * 0.01
        
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: newCameraYPosition, z: 15)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func spawnShape() {
        var geometry:SCNGeometry
        switch ShapeType.random() {
        case .cone:
            geometry = SCNCone(topRadius: 0.25, bottomRadius: 0.5, height: 1)
        case .capsule:
            geometry = SCNCapsule(capRadius: 0.3, height: 2.5)
        case .tube:
            geometry = SCNTube(innerRadius: 0.25, outerRadius: 0.5, height: 1.0)
        case .sphere:
            geometry = SCNSphere(radius: 0.5)
        case .torus:
            geometry = SCNTorus(ringRadius: 0.5, pipeRadius: 0.5)
        case .pyramid:
            geometry = SCNPyramid(width: 1.0, height: 1.0, length: 1.0)
        case .cylinder:
            geometry = SCNCylinder(radius: 0.3, height: 2.5)
        case .box:
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        }
        let geometryNode = SCNNode(geometry: geometry)
        scnScene.rootNode.addChildNode(geometryNode)
        
        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        let randomX = Float.random(min: -3, max: 3)
        let randomY = Float.random(min: 8, max: 20)
        let force = SCNVector3(x: randomX, y: randomY, z: 0)
        let position = SCNVector3(x: 0.07, y: 0.07, z: 0.07)
        
        geometryNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
        geometry.materials.first?.diffuse.contents = UIColor.random()
        geometry.materials.first?.specular.contents = UIColor(named: "#fff")
    }
    
    func cleanUp() {
        for node in scnScene.rootNode.childNodes {
            if node.presentation.position.y < -10 {
                node.removeFromParentNode()
            }
        }
    }
}

extension GameViewController:SCNSceneRendererDelegate {
    
    func renderer(_ renderer:SCNSceneRenderer, updateAtTime time:TimeInterval) {
//        spawnShape()
        // leaving this as is, we are spawning 60 shapes per second
        
        // what is time??
//        print("time: \(time)")
        
        if time > spawnTime {
            spawnShape()
            spawnTime = time + TimeInterval(Float.random(min: 0.3, max: 1.8))
        }
        
        cleanUp()
    }
    
}
































