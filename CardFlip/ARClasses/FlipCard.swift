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

class FlipCard: Entity, HasModel, HasCollision, HasCard {

  var card: CardComponent {
    get { components[CardComponent] ?? CardComponent(id: -1) }
    set { components[CardComponent] = newValue }
  }

  /// Initialise a FlipCard in the scene
  /// - Parameter color: color of your card to be
  /// - Parameter id: the input id is used for matching the card to an equal
  init(color: UIColor, id: Int) {
    super.init()
    self.components[CardComponent] = CardComponent(id: id)
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

  /// Does this card match another card, you must first make sure these cards are not the same Entity
  /// - Parameter match: card for checking the match against
  func matches(with match: FlipCard) -> Bool {
    return self.cardID == match.cardID
  }
}

// MARK: - FlipCard Animations
extension FlipCard {
  // TODO: Find why the animations occur instantly, rather than in duration
  
  /// Flip the card to reveal the underside
  /// - Parameter completion: Any actions you want to happen upon completion
  func reveal(completion: (() -> Void)? = nil) {
    card.isRevealed = true
    var transform = self.transform
    transform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
    move(to: transform, relativeTo: parent, duration: 0.25, timingFunction: .easeOut).completionHandler {
      completion?()
    }
  }
  func hide(completion: (() -> Void)? = nil) {
    card.isRevealed = true
    var transform = self.transform
    transform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
    move(to: transform, relativeTo: parent, duration: 0.25, timingFunction: .easeOut).completionHandler {
      self.card.isRevealed = false
      completion?()
    }
  }
}
