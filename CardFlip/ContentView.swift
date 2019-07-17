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

struct ContentView : View {
  var body: some View {
    RealityIntegratedViewController()
      .edgesIgnoringSafeArea(.all)
//            return ARViewContainer().edgesIgnoringSafeArea(.all)
  }
}

struct RealityIntegratedViewController: UIViewControllerRepresentable {
  func makeUIViewController(
    context: UIViewControllerRepresentableContext<
    RealityIntegratedViewController
    >
    ) -> RealityViewController {
    RealityViewController()
  }

  //  typealias UIViewControllerType = RealityViewController
  func updateUIViewController(
    _ uiViewController: RealityViewController,
    context: UIViewControllerRepresentableContext<
    RealityIntegratedViewController
    >
    ) {
  }
}


/// This view is not currently used, instead the struct above is
struct ARViewContainer: UIViewRepresentable {

  func makeUIView(context: Context) -> ARView {

    let arView = ARView(frame: .zero)

    // Load the "Box" scene from the "Experience" Reality File
    if let flipTable = try? FlipTable(dimensions: [2,2]) {
      flipTable.minimumBounds = [0.3,0.3]
      arView.scene.anchors.append(flipTable)
    } else {
      print("couldnt make flip table")
    }

    return arView

  }

  func updateUIView(_ uiView: ARView, context: Context) {}

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
