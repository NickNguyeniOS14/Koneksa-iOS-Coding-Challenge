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

    private let motion = CMMotionManager()

    private let persister = Persister(withFileName: "AccelerometerData")

    @State private var x: Double = 0
    @State private var y: Double = 0
    @State private var z: Double = 0
    @State private var isVisible: Bool = false

    // MARK: - View

    var body: some View {

        VStack {
            VStack {
                Text("X:\(x)")
                Text("Y:\(y)")
                Text("Z:\(z)")
            }
            .opacity(!isVisible ? 0 : 1)
            .font(.custom("Menlo-Regular", size: 19))

            Divider()

            Button("Start") {
                startAccelerometers()
            }
            .opacity(isVisible ? 0 : 1)
        }
        .onAppear {
            /* Check to see if data is stored to disk properly by printing it out on console after app's launch
             or use this reference: https://stackoverflow.com/questions/38064042/access-files-in-var-mobile-containers-data-application-without-jailbreaking-iph/38064225
             */
            if let accelerometerData: [String] = try? persister?.fetch() {
                accelerometerData.forEach { (data) in
                    print(data)
                }
            }
        }
    }

    // MARK: - Action

    func startAccelerometers() {

        var accelerometerData = [String]()

        isVisible.toggle()
        
        var cycles: Double = 0.0

        // Make sure the accelerometer hardware is available.

        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = 1.0 / 50.0  // 50 Hz
            motion.startAccelerometerUpdates()

            // Configure a timer to fetch the data.

            let timer = Timer(
                fire: Date(),
                interval: (1.0 / 50.0),
                repeats: true,
                block: { timer in
                    cycles += 1
                    // Get the accelerometer data.
                    if let data = motion.accelerometerData {

                        x = data.acceleration.x
                        y = data.acceleration.y
                        z = data.acceleration.z

                        let stringData = "X: \(x),Y: \(y),Z:\(z)"

                        accelerometerData.append(stringData)

                        /* The timer runs 50 cycles per second, 10 seconds will equal 500 cycles,
                         that's when we need to stop and write data to disk. */

                        if cycles == 500.0 {
                            timer.invalidate()
                            motion.stopAccelerometerUpdates()
                            isVisible.toggle()
                            persister?.save(accelerometerData)
                        }
                    }
                }
            )
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
