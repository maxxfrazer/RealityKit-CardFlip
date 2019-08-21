//
//  CardFlipARView.swift
//  CardFlip
//
//  Created by Max Cobb on 7/17/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import RealityKit
import ARKit
import Combine

struct GameData {
  var dimensions: SIMD2<Int> = [4,4]
  var cardsFound: Int = 0
  var totalCards: Int {
    dimensions[0] * dimensions[1]
  }
}

class CardFlipARView: ARView, ARSessionDelegate {
  let coachingOverlay = ARCoachingOverlayView()
  var tableAdded = false

  var status: GameStatus = .initCoaching {
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

  var waitForAnchor: Cancellable?

  var gameData = GameData()

  /// Add the FlipTable object
  func addFlipTable() {
    if let flipTable = try? FlipTable(dimensions: gameData.dimensions) {
      if tableAdded {
        return
      }
      self.flipTable = flipTable
      self.tableAdded = true
      flipTable.minimumBounds = [0.5,0.5]
      self.status = .planeSearching

      // Subscribe to the AnchoredStateChanged event for flipTable
      self.waitForAnchor = self.scene.subscribe(
        to: SceneEvents.AnchoredStateChanged.self,
        on: flipTable
      ) { event in
        if event.isAnchored {
          self.status = .positioning
          DispatchQueue.main.async {
            self.waitForAnchor?.cancel()
            self.waitForAnchor = nil
          }
        }
      }
      self.scene.anchors.append(flipTable)
    } else {
      print("couldnt make flip table")
    }
  }
  func cardFound() {
    self.gameData.cardsFound += 2
    if self.gameData.cardsFound == self.gameData.totalCards {
      gameComplete()
    } else {
      self.currentlyFlipped = nil
      self.canTap = true
    }
  }
  func gameComplete() {
    // TODO: Make make this nicer next, in many ways.
    self.status = .finished
    let finText = ModelEntity(
      mesh: .generateText(
        "Winner!",
        extrusionDepth: 0.1,
        font: .systemFont(ofSize: 0.5),
        containerFrame: CGRect(
          origin: .zero,
          size: CGSize(width: 2, height: 1)),
        alignment: .center,
        lineBreakMode: .byWordWrapping
      ), materials: [SimpleMaterial(color: .yellow, isMetallic: true)]
    )
    finText.position.y = 1
    self.flipTable?.addChild(finText)
  }
}
