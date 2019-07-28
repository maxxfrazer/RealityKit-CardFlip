//
//  CardComponent.swift
//  CardFlip
//
//  Created by Max Cobb on 7/25/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import RealityKit

struct CardComponent: Component, Codable {
  var isRevealed = false
  var id: Int
}

protocol HasCard {
  var card: CardComponent { get set }
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
  // TODO: Find why the animations occur instantly, rather than in duration

  /// Flip the card to reveal the underside
  /// - Parameter completion: Any actions you want to happen upon completion
  mutating func reveal(completion: (() -> Void)? = nil) {
    card.isRevealed = true
    var transform = self.transform
    transform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
    move(to: transform, relativeTo: parent, duration: 0.25, timingFunction: .easeOut).completionHandler {
      completion?()
    }
  }
  mutating func hide(completion: (() -> Void)? = nil) {
    var cSelf = self
    var transform = self.transform
    transform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
    move(to: transform, relativeTo: parent, duration: 0.25, timingFunction: .easeOut).completionHandler {
      cSelf.isRevealed = false
      completion?()
    }
  }
}
