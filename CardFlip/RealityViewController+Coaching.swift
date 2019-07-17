//
//  RealityViewController+Coaching.swift
//  CardFlip
//
//  Created by Max Cobb on 7/17/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import ARKit
import UIKit

extension RealityViewController: ARCoachingOverlayViewDelegate {
  /// - Tag: HideUI
  func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
    print("Coaching starting")
  }

  /// - Tag: PresentUI
  func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
    print("coaching deactivated")
    self.coachingFinished()
  }

  //  /// - Tag: StartOver
  //  func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
  //    restartExperience()
  //  }

  func setupCoachingOverlay() {
    // Set up coaching view
    coachingOverlay.session = self.arView.session
    coachingOverlay.delegate = self

    coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
    self.arView.addSubview(coachingOverlay)

    NSLayoutConstraint.activate([
      coachingOverlay.centerXAnchor.constraint(equalTo: self.arView.centerXAnchor),
      coachingOverlay.centerYAnchor.constraint(equalTo: self.arView.centerYAnchor),
      coachingOverlay.widthAnchor.constraint(equalTo: self.arView.widthAnchor),
      coachingOverlay.heightAnchor.constraint(equalTo: self.arView.heightAnchor)
    ])

    setActivatesAutomatically()

    // Most of the virtual objects in this sample require a horizontal surface,
    // therefore coach the user to find a horizontal plane.
    setGoal()
  }

  /// - Tag: CoachingActivatesAutomatically
  func setActivatesAutomatically() {
    coachingOverlay.activatesAutomatically = true
  }

  /// - Tag: CoachingGoal
  func setGoal() {
    coachingOverlay.goal = .horizontalPlane
  }

}
