//
//  ARButton.swift
//  CardFlip
//
//  Created by Max Cobb on 7/28/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import RealityKit

class ARButton: Entity, HasCollision, HasModel, HasTap {
  var tapAction: (() -> Void)?

  init(transform: Transform, model: ModelComponent, tapAction: (() -> Void)? = nil) {
    self.tapAction = tapAction
    super.init()
    self.model = model
    self.transform = transform
    self.generateCollisionShapes(recursive: false)
  }

  required init() {
    super.init()
  }
}
