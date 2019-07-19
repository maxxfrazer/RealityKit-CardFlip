//
//  FlipTable.swift
//  CardFlip
//
//  Created by Max Cobb on 7/16/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import RealityKit
import UIKit

enum FlipTableError: Error {
  case unevenDimensions
  case dimensionsTooLarge
}



class FlipTable: Entity, HasAnchoring {
  static var availableColors: [UIColor] = [
    .red,
    .orange,
    .yellow,
    .green,
    .blue,
    .purple,
    .brown,
    .systemPink,
  ]
  /// After 2 non matching cards are flipped, they will flip back to non-reveal state after this time in seconds
  var flipBackTimeout = 0.5
  let dimensions: SIMD2<Int>
  var minimumBounds: SIMD2<Float>? = nil {
    didSet {
      guard let bounds = minimumBounds else {
        return
      }
      let anchorPlane = AnchoringComponent.Target.plane(
        .horizontal,
        classification: .any,
        minimumBounds: bounds)
      let anchorComponent = AnchoringComponent(anchorPlane)

      self.components[AnchoringComponent] = anchorComponent
      let maxDim = dimensions.max()
      let minBound = bounds.min()
      self.scale = .init(repeating: minBound / Float(maxDim))
    }
  }
  init(dimensions: SIMD2<Int>) throws {
    CardComponent.self.registerComponent()
    self.dimensions = dimensions
    let cardCount = dimensions[0] * dimensions[1]
    if (cardCount % 2) == 1 {
      throw FlipTableError.unevenDimensions
    } else if (cardCount) > (FlipTable.availableColors.count * 2) {
      throw FlipTableError.dimensionsTooLarge
    }
    super.init()
    let colorsToUse = FlipTable.availableColors[0...((cardCount - 1) / 2)]
    let allIDs = Array(0..<cardCount).map { $0 / 2 }.shuffled()
    for row in 0..<dimensions[0] {
      for col in 0..<dimensions[1] {
        let positionIndex = row * dimensions[0] + col
        let colorIndex = allIDs[positionIndex]
        let newCard = FlipCard(color: colorsToUse[colorIndex], id: colorIndex)
        newCard.scale = [0.9, 0.9, 0.9]
        newCard.position = [
          Float(col) - Float(dimensions[1] - 1) / 2,
          0,
          Float(row) - Float(dimensions[0] - 1) / 2
        ]
        self.addChild(newCard)
      }
    }
  }

  required init() {
    fatalError("FlipTable requires a size in initializer")
  }
}
