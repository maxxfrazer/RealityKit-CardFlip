//
//  RealityViewController+Gestures.swift
//  CardFlip
//
//  Created by Max Cobb on 7/18/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import SwiftUI

extension RealityViewController: UIGestureRecognizerDelegate {

  /// Add the tap gesture recogniser
  func setupGestures() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    self.arView.addGestureRecognizer(tap)
  }

  /// Handle taps on the screen, currently exclusively used for flipping cards
  @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
    guard let touchInView = sender?.location(in: self.arView), self.canTap else {
      return
    }
    /// If we don't have any more left, do not add
    guard let boardUnit = self.arView.entity(at: touchInView) as? FlipCard else {
      // not a FlipCard
      return
    }
    if !boardUnit.isRevealed {
      self.canTap = false

      boardUnit.reveal()

      if self.currentlyFlipped == nil {
        self.currentlyFlipped = boardUnit
        self.canTap = true
      } else if let currentlyFlipped = self.currentlyFlipped, !currentlyFlipped.matches(with: boardUnit) {
        // not a match
        DispatchQueue.main.asyncAfter(deadline: .now() + (self.flipTable?.flipBackTimeout ?? 0.5)) {
          boardUnit.hide()
          currentlyFlipped.hide(completion: {
            self.canTap = true
            self.currentlyFlipped = nil
          })
        }
      } else {
        // score increase by 2
        self.currentlyFlipped = nil
        self.canTap = true
      }
    }
  }
}
