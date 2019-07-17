//
//  RealityViewController.swift
//  CardFlip
//
//  Created by Max Cobb on 7/17/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import RealityKit
import ARKit

class RealityViewController: UIViewController, ARSessionDelegate {
  let arView = ARView(frame: .zero)

  // MARK: - Touch Gesture Variables
  var touchStartedOn: FlipCard? = nil
  var currentlyFlipped: FlipCard? = nil
  var canTap = true

  let coachingOverlay = ARCoachingOverlayView()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupARView()
    setupCoachingOverlay()
    setupGestures()
  }

  func coachingFinished() {
  }

  func setupARView() {
    self.modalPresentationStyle = .fullScreen
    arView.frame = self.view.bounds
    self.arView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.view.addSubview(arView)
    // MARK: - Add FlipTable
    if let flipTable = try? FlipTable(dimensions: [4,4]) {
      flipTable.minimumBounds = [0.5,0.5]
      arView.scene.anchors.append(flipTable)
    } else {
      fatalError("couldnt make flip table, check parameters")
    }
  }
}
