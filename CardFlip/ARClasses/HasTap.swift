//
//  HasTap.swift
//  CardFlip
//
//  Created by Max Cobb on 7/28/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import Foundation

protocol HasTap {
  var tapAction: (() -> Void)? { get set }
}
