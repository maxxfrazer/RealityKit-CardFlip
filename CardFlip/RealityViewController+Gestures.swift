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
    if !boardUnit.isFaceUp {
      self.canTap = false
      var boardTransform = boardUnit.transform
      boardTransform.rotation = .init(angle: .pi, axis: [1,0,0])

      // TODO: Find why the animations occur instantly, rather than in duration
      boardUnit.move(
        to: boardTransform,
        relativeTo: boardUnit.parent,
        duration: 0.3,
        timingFunction: .easeInOut
      )

      boardUnit.isFaceUp = true
      if self.currentlyFlipped == nil {
        self.currentlyFlipped = boardUnit
        self.canTap = true
      } else if let currentlyFlipped = self.currentlyFlipped, currentlyFlipped.cardID != boardUnit.cardID {
        // not a match
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          boardTransform.rotation = .init(angle: 0, axis: [1, 0, 0])
          boardUnit.move(to: boardTransform, relativeTo: boardUnit.parent, duration: 0.3, timingFunction: .easeInOut)
          var firstCardTransform = currentlyFlipped.transform
          firstCardTransform.rotation = .init(angle: 0, axis: [1, 0, 0])
          currentlyFlipped.move(to: firstCardTransform, relativeTo: boardUnit.parent, duration: 0.3, timingFunction: .easeInOut).completionHandler {
            self.canTap = true
            boardUnit.isFaceUp = false
            self.currentlyFlipped?.isFaceUp = false
            self.currentlyFlipped = nil
          }
        }
      } else {
        // score increase by 2
        self.currentlyFlipped = nil
        self.canTap = true
      }
    }
  }
}
