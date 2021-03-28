//
//  ContentView.swift
//  Koneksa
//
//  Created by Nick Nguyen on 3/28/21.
//

import SwiftUI
import CoreMotion

struct ContentView: View {

    let motion = CMMotionManager()
    let queue = OperationQueue()
    let recorder = CMSensorRecorder()

    @State private var x: Double = 0
    @State private var y: Double = 0
    @State private var z: Double = 0
    @State private var isVisible: Bool = false


    var body: some View {

        VStack {
            Text("X: \(x),Y: \(y),Z: \(z)")
                .opacity(!isVisible ? 0 : 1)

            Divider()

            Button("Start") {
                print("GET accelerometer data for 10 seconds")
                // After 10 seconds, write to disk
                startAccelerometers()
            }
            .opacity(isVisible ? 0 : 1)
        }
    }

    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        isVisible.toggle()
        var count: Double = 0

        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = 1.0 / 50.0  // 50 Hz
            motion.startAccelerometerUpdates()

            // Configure a timer to fetch the data.

            let timer = Timer(fire: Date(),
                              interval: (1.0 / 50.0),
                              repeats: true,
                              block: { timer in
                                // Get the accelerometer data.
                                count += 1
                                print(count)
                                if let data = motion.accelerometerData {
                                    // Use the accelerometer data in your app.
                                    x = data.acceleration.x
                                    y = data.acceleration.y
                                    z = data.acceleration.z
                                }
                                if count == 500.0 {
                                    motion.stopAccelerometerUpdates()
                                    timer.invalidate()
                                    isVisible.toggle()
                                }
                              })

            // Add the timer to the current run loop.
            RunLoop.current.add(timer, forMode: .default)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
extension CMSensorDataList: Sequence {
    public typealias Iterator = NSFastEnumerationIterator
    public func makeIterator() -> NSFastEnumerationIterator {
        return NSFastEnumerationIterator(self)
    }
}
