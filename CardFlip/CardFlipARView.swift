//
//  CardFlipARView.swift
//  CardFlip
//
//  Created by Max Cobb on 7/17/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import RealityKit
import ARKit

enum GameStatus {
  case planeSearching
  case positioning
  case playing
}

class CardFlipARView: ARView, ARSessionDelegate {
  let coachingOverlay = ARCoachingOverlayView()
  var tableAdded = false

  // MARK: - Touch Gesture Variables
  var touchStartedOn: FlipCard? = nil
  var currentlyFlipped: FlipCard? = nil
  var canTap = true
  var flipTable: FlipTable? = nil
  var confirmButton: ARButton?
  var installedGestures: [EntityGestureRecognizer] = []

  var status: GameStatus = .planeSearching {
    didSet {
      switch status {
      case .positioning:
        setToPositioningStatus()
      default:
        print("status is: \(status)")
      }
    }
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
      self.flipTable?.components[CollisionComponent] = nil
      self.confirmButton?.removeFromParent()
      self.status = .playing
      self.installedGestures = self.installedGestures.filter({ (recogniser) -> Bool in
        recogniser.isEnabled = false
        return false
      })
    }
    self.confirmButton = confirmButton
    self.flipTable?.addChild(confirmButton)

  }

  /// Add the FlipTable object
  func addFlipTable() {
    if let flipTable = try? FlipTable(dimensions: [4,4]) {
      if tableAdded {
        return
      }
      self.flipTable = flipTable
      self.tableAdded = true
      flipTable.minimumBounds = [0.5,0.5]
      self.scene.anchors.append(flipTable)
    } else {
      print("couldnt make flip table")
    }
  }
  func session(_ session: ARSession, didUpdate frame: ARFrame) {
    if self.status == .planeSearching {
      if self.flipTable?.isAnchored ?? false {
        self.status = .positioning

//        self.status = .playing
      }
    }
  }
}
