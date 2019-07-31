//
//  CardFlipARView.swift
//  CardFlip
//
//  Created by Max Cobb on 7/17/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import RealityKit
import ARKit

class CardFlipARView: ARView {
  let coachingOverlay = ARCoachingOverlayView()
  var tableAdded = false


  var status: GameStatus = .planeSearching {
    didSet {
      switch oldValue {
      case .positioning:
        changedFromPositioningStatus()
      default:
        print("status was: \(status)")
      }
      switch status {
      case .positioning:
        setToPositioningStatus()
      default:
        print("status is: \(status)")
      }
    }
  }

  // MARK: - Touch Gesture Variables
  var touchStartedOn: FlipCard? = nil
  var currentlyFlipped: FlipCard? = nil
  var canTap = true
  var flipTable: FlipTable? = nil
  var confirmButton: ARButton?
  var installedGestures: [EntityGestureRecognizer] = []

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
}
