//
//  ContentView.swift
//  Koneksa
//
//  Created by Nick Nguyen on 3/28/21.
//

import SwiftUI
import CoreMotion

struct ContentView: View {

  // MARK: - Properties

  @StateObject var accelerometerManager = AccelerometerManager()

  // MARK: - View

  var body: some View {

    VStack {
      VStack {
        Text("X:\(accelerometerManager.x)")
        Text("Y:\(accelerometerManager.y)")
        Text("Z:\(accelerometerManager.z)")
      }
      .opacity(!accelerometerManager.isVisible ? 0 : 1)
      .font(.custom("Menlo-Regular", size: 19))

      Divider()

      Button("Start") {
        accelerometerManager.startAccelerometers()
      }
      .opacity(accelerometerManager.isVisible ? 0 : 1)
    }
    .onAppear {
      /* Check to see if data is stored to disk properly by printing it out on console after app's launch
       or use this reference: https://stackoverflow.com/questions/38064042/access-files-in-var-mobile-containers-data-application-without-jailbreaking-iph/38064225
       */
      if let accelerometerData: [String] = try? accelerometerManager.persister?.fetch() {
        accelerometerData.forEach { (data) in
          print(data)
        }
      }
    }
  }

  // MARK: - Preview Provider

  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
  }
}
