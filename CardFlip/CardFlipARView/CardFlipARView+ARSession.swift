//
//  CardFlipARView+ARSession.swift
//  CardFlip
//
//  Created by Max Cobb on 7/31/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import ARKit

extension CardFlipARView: ARSessionDelegate {
  func session(_ session: ARSession, didUpdate frame: ARFrame) {
    if self.status == .planeSearching {
      if self.flipTable?.isAnchored ?? false {
        self.status = .positioning
      }
    }
  }
}
