//
//  ViewController.swift
//  SolarSystem
//
//  Created by Faiq on 28/12/2020.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/solarSystem.scn")!
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        //Calling our func
        createSolarSystem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK:- Helper Functions
    func createSolarSystem() {
        //Parent Node
        let parentNode = SCNNode()
        parentNode.position.z = -1.5  //1.5m infront of us
        
        //Planets
        let mercury = Planet(name: "mercury",
                             radius: 0.14,
                             rotation: 32.degreesToRadians,
                             color: .orange,
                             sunDistance: 1.3)
        
        let venus = Planet(name: "venus",
                           radius: 0.35,
                           rotation: 10.degreesToRadians,
                           color: .cyan,
                           sunDistance: 2)
        
        let earth = Planet(name: "earth",
                           radius: 0.5,
                           rotation: 18.degreesToRadians,
                           color: .blue,
                           sunDistance: 7)
        
        let saturn = Planet(name: "saturn",
                            radius: 1,
                            rotation: 12.degreesToRadians,
                            color: .brown,
                            sunDistance: 12)
        
        let planets = [mercury, venus, earth, saturn]
        
        for planet in planets {
            parentNode.addChildNode(createNode(from: planet))
        }
        
        //Add Light
        let light = SCNLight()
        light.type = .omni
        parentNode.light = light 
        
        //Add Stars
        guard let stars = SCNParticleSystem(named: "stars.scnp", inDirectory: nil) else {return}
        parentNode.addParticleSystem(stars)
        
        //Add Sun
        guard let sun = SCNParticleSystem(named: "sun.scnp", inDirectory: nil) else {return}
        parentNode.addParticleSystem(sun)
        
        // Add parent node to our solar system
        sceneView.scene.rootNode.addChildNode(parentNode)
        
    }
    
    func createNode(from planet: Planet) -> SCNNode{
        //Parent(sun) for rotation
        let parentNode = SCNNode()
        
        //set a rotate action
        let rotateAction = SCNAction.rotateBy(x: 0, y: planet.rotation, z: 0, duration: 1)
        parentNode.runAction(.repeatForever(rotateAction))
        
        //setting geometry of a planet
        let sphereGeometry = SCNSphere(radius: planet.radius)
        sphereGeometry.firstMaterial?.diffuse.contents = planet.color
        
        let planetNode = SCNNode(geometry: sphereGeometry)
        planetNode.position.z = -planet.sunDistance
        planetNode.name = planet.name
        
        parentNode.addChildNode(planetNode)
        
        //For saturn rings
        if planet.name == "saturn" {
            let ringGeometry = SCNTube(innerRadius: 1.2, outerRadius: 1.8, height: 0.05)
            ringGeometry.firstMaterial?.diffuse.contents = UIColor.darkGray
            
            //add angle to the ring
            let ringNode = SCNNode(geometry: ringGeometry)
            ringNode.eulerAngles.x = Float(10.degreesToRadians)
            
            //add ringNode to planet Node (saturn)
            planetNode.addChildNode(ringNode)
        }
        
        return parentNode
    }

}

//MARK:- Extensions
extension Int {
    var degreesToRadians: CGFloat{
        return CGFloat(self) * .pi/180
    }
}
