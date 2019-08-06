//
//  CardComponent.swift
//  CardFlip
//
//  Created by Max Cobb on 7/25/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import Foundation
import RealityKit
import Combine

struct CardComponent: Component, Codable {
  var isRevealed = false
  var id: Int
}

protocol HasCard {
  var card: CardComponent { get set }
  var revealAnimationCallback: Cancellable? { get set }
  var hideAnimationCallback: Cancellable? { get set }
}

extension HasCard where Self: Entity {
  var cardID: Int {
    self.card.id
  }
  var isRevealed: Bool {
    get { self.card.isRevealed }
    set { self.card.isRevealed = newValue }
  }
}

// MARK: - FlipCard Animations
extension HasCard where Self: Entity {

  /// Flip the card to reveal the underside
  /// - Parameter completion: Any actions you want to happen upon completion
  mutating func reveal(completion: (() -> Void)? = nil) {
    card.isRevealed = true
    var transform = self.transform
    transform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
    let myEvent = move(to: transform, relativeTo: parent, duration: 0.25, timingFunction: .easeOut)
    self.revealAnimationCallback = self.scene?.subscribe(to: AnimationEvents.PlaybackTerminated.self, on: self, { (event) in
      guard event.playbackController == myEvent else { return }
      completion?()
    })
  }

  /// Flip the card back to hide the underside
  /// - Parameter completion: Any actions you want to happen upon completion
  mutating func hide(completion: (() -> Void)? = nil) {
    var cSelf = self
    var transform = self.transform
    transform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
    let myEvent = move(to: transform, relativeTo: parent, duration: 0.25, timingFunction: .easeOut)
    self.hideAnimationCallback = self.scene?.subscribe(to: AnimationEvents.PlaybackTerminated.self, on: self, { (event) in
      if (event.playbackController == myEvent) {
        cSelf.isRevealed = false
        cSelf.hideAnimationCallback = nil
        completion?()
      }
    })
  }
}
