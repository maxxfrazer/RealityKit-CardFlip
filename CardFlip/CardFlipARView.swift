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

  // MARK: - Touch Gesture Variables
  var touchStartedOn: FlipCard? = nil
  var currentlyFlipped: FlipCard? = nil
  var canTap = true
  var flipTable: FlipTable? = nil

  /// Add the FlipTable object
  func addFlipTable() {
    if let flipTable = try? FlipTable(dimensions: [4,4]) {
      if tableAdded {
        return
      }
      tableAdded = true
      flipTable.minimumBounds = [0.5,0.5]
      self.scene.anchors.append(flipTable)
    } else {
      print("couldnt make flip table")
    }
  }
}
