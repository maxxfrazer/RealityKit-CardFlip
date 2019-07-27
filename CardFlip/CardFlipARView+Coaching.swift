//
//  CardFlipARView+Coaching.swift
//  CardFlip
//
//  Created by Max Cobb on 7/17/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import ARKit
import UIKit

extension CardFlipARView: ARCoachingOverlayViewDelegate {
  func addCoaching() {
    self.coachingOverlay.delegate = self
    self.coachingOverlay.session = self.session
    self.coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    /// - Tag: CoachingGoal
    self.coachingOverlay.goal = .horizontalPlane
    self.addSubview(self.coachingOverlay)
  }
  public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
    coachingOverlayView.activatesAutomatically = false
    self.addFlipTable()
  }
}
