//
//  Planet.swift
//  SolarSystem
//
//  Created by Faiq on 29/12/2020.
//

import UIKit

class Planet {
    
    var name: String
    var radius: CGFloat
    var rotation: CGFloat
    var color: UIColor
    var sunDistance: Float
    
    init(name: String, radius: CGFloat, rotation: CGFloat, color: UIColor, sunDistance: Float) {
        self.name = name
        self.radius = radius
        self.rotation = rotation
        self.color = color
        self.sunDistance = sunDistance
    }
    
    
}
