//
//  AccelerometerManager.swift
//  Koneksa
//
//  Created by Nick Nguyen on 5/28/21.
//

import Foundation
import CoreMotion

final class AccelerometerManager: ObservableObject {
  
  private let motion = CMMotionManager()
  
  let persister = Persister(withFileName: "AccelerometerData")
  
  @Published var x: Double = 0
  @Published var y: Double = 0
  @Published var z: Double = 0
  @Published var isVisible: Bool = false
  
   func startAccelerometers() {
    
    var accelerometerData = [[Double]]()
    
    isVisible.toggle()
    
    var cycles: Double = 0.0
    
    // Make sure the accelerometer hardware is available.
    
    if motion.isAccelerometerAvailable {
      motion.accelerometerUpdateInterval = 1.0 / 50.0  // 50 Hz
      motion.startAccelerometerUpdates()
      
      // Configure a timer to fetch the data.
      
      let _ = Timer(
        fire: Date(),
        interval: (1.0 / 50.0),
        repeats: true,
        block: { timer in
          
          // Get the accelerometer data.
          guard let data = self.motion.accelerometerData else {
            timer.invalidate()
            return
          }
          
          cycles += 1
          self.x = data.acceleration.x
          self.y = data.acceleration.y
          self.z = data.acceleration.z
          
          let valueData = [self.x,self.y,self.z]
          
          accelerometerData.append(valueData)
          
          /* The timer runs 50 cycles per second, 10 seconds will equal 500 cycles,
           that's when we need to stop and write data to disk. */
          
          if cycles == 500.0 {
            timer.invalidate()
            self.motion.stopAccelerometerUpdates()
            self.isVisible.toggle()
            self.persister?.save(accelerometerData)
          }
          
          
          // Add the timer to the current run loop.
          RunLoop.current.add(timer, forMode: .default)
        })
    }
  }
}

