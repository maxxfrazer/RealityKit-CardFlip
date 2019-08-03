//
//  CardFlipARView+GameStatus.swift
//  CardFlip
//
//  Created by Max Cobb on 7/31/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import RealityKit

enum GameStatus {
  case planeSearching
  case positioning
  case playing
  case finished
}

extension CardFlipARView {

  func changedFromPositioningStatus() {
    self.flipTable?.components[CollisionComponent] = nil
    self.confirmButton?.removeFromParent()
    self.installedGestures = self.installedGestures.filter({ (recogniser) -> Bool in
      recogniser.isEnabled = false
      return false
    })
  }
  func setToPositioningStatus() {
    guard let table = self.flipTable else {
      return
    }
    table.components[CollisionComponent] = CollisionComponent(shapes: [.generateBox(size: [4, 0.4, 4])])
    self.installedGestures.append(
      contentsOf: self.installGestures([.translation, .rotation], for: table)
    )

    // TODO: - Change the button, maybe change to 2D UIButton?
    let confirmButton = self.confirmButton ?? ARButton(
      transform: Transform(
        scale: [1, 1, 1],
        rotation: simd_quatf(angle: 0, axis: [1,0,0]),
        translation: [-0.5, 1.0, 0]),
      model: ModelComponent(
        mesh: .generateSphere(radius: 0.4),
        materials: [SimpleMaterial(color: .green, isMetallic: false)]
    )) {
      self.status = .playing
    }
    self.confirmButton = confirmButton
    self.flipTable?.addChild(confirmButton)

  }
}
