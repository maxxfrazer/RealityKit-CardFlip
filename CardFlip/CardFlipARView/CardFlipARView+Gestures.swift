//
//  CardFlipARView+Gestures.swift
//  CardFlip
//
//  Created by Max Cobb on 7/18/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import SwiftUI

extension CardFlipARView {

  /// Add the tap gesture recogniser
  func setupGestures() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    self.addGestureRecognizer(tap)
  }

  /// Handle taps on the screen, currently exclusively used for flipping cards
  @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
    switch self.status {
    case .positioning:
      tapWhenPositioning(sender)
    case .playing:
      cardFlipAction(sender)
    default:
      return
    }
  }

  func tapWhenPositioning(_ sender: UITapGestureRecognizer? = nil) {
    guard let touchInView = sender?.location(in: self), self.canTap else {
      return
    }
    /// If we don't have any more left, do not add
    guard let buttonTapped = self.entity(at: touchInView) as? ARButton else {
      // not a FlipCard or nothing hit
      return
    }
    buttonTapped.tapAction?()
  }

  func cardFlipAction(_ sender: UITapGestureRecognizer? = nil) {
    guard let touchInView = sender?.location(in: self), self.canTap else {
      return
    }
    /// If we don't have any more left, do not add
    guard var boardUnit = self.entity(at: touchInView) as? FlipCard else {
      // not a FlipCard or nothing hit
      return
    }
    if !boardUnit.isRevealed {
      self.canTap = false

      boardUnit.reveal()

      if self.currentlyFlipped == nil {
        self.currentlyFlipped = boardUnit
        self.canTap = true
      } else if var currentlyFlipped = self.currentlyFlipped, !currentlyFlipped.matches(with: boardUnit) {
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
        cardFound()
      }
    }
  }
}
