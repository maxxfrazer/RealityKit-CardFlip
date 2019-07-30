//
//  ContentView.swift
//  CardFlip
//
//  Created by Max Cobb on 7/16/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView: View {
  var body: some View {
    return ARViewContainer().edgesIgnoringSafeArea(.all)
  }
}

/// This view is not currently used, instead the struct above is
struct ARViewContainer: UIViewRepresentable {
  func makeUIView(context: Context) -> CardFlipARView {

    let arView = CardFlipARView(frame: .zero)
    let config = ARWorldTrackingConfiguration()
    config.planeDetection = [.horizontal]
    arView.session.run(config, options: [])
    CardComponent.registerComponent()

    arView.addCoaching()
    arView.setupGestures()
    arView.session.delegate = arView
    return arView
  }
  func updateUIView(_ uiView: CardFlipARView, context: Context) {}

}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
