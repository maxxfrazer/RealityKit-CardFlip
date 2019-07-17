//
//  FlipCard.swift
//  CardFlip
//
//  Created by Max Cobb on 7/18/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import RealityKit
import UIKit

fileprivate extension UIColor {
  func toMaterial(isMetallic: Bool = false) -> Material {
    return SimpleMaterial.init(color: self, isMetallic: isMetallic)
  }
}

class FlipCard: Entity, HasModel, HasCollision {
  let cardID: Int
  var isFaceUp = false
  init(color: UIColor, id: Int) {
    self.cardID = id
    super.init()
    let coloredFace = ModelEntity(
      mesh: MeshResource.generatePlane(width: 1, depth: 1),
      materials: [color.toMaterial()]
    )
    coloredFace.orientation = .init(angle: .pi, axis: [1,0,0])
    coloredFace.position.y = -0.101

    self.addChild(coloredFace)
    self.components[ModelComponent] = ModelComponent(
      mesh: .generateBox(size: [1, 0.2, 1]),
      materials: [UIColor.gray.toMaterial()])
    self.components[CollisionComponent] = CollisionComponent(
      shapes: [ShapeResource.generateBox(size: [1,0.2,1])]
    )
  }

  required init() {
    fatalError("init() has not been implemented")
  }
}
