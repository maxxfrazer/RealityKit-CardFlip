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
    return self.card.isRevealed
  }
}
