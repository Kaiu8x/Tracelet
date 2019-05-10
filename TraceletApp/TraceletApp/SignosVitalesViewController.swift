//
//  SignosVitalesViewController.swift
//  TraceletApp
//
//  Created by kenyiro tsuru on 3/18/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//
/*
 let now = Date()
 
 let formatter = DateFormatter()
 
 formatter.timeZone = TimeZone.current
 
 formatter.dateFormat = "yyyy-MM-dd HH:mm"
 
 let dateString = formatter.string(from: now)
 */
import UIKit
import Firebase


class SignosVitalesViewController: UIViewController {
    
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }
    
    @IBAction func desaparecer(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


/*
class SignosVitalesViewController: UIViewController {

    private let authorizeHealthKitSection = 2
    private let userHealthProfile = UserHealthProfile()
    //locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    
    
    
    private func authorizeHealthKit(_ sender: Any) {
        
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            print("HealthKit Successfully Authorized.")
            
            self.loadAndDisplayMostRecentDistance()
            self.loadAndDisplayMostRecentHeartRate()
        }
 
    }
    
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    /*
    @IBAction func desaparecerVista(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
 */
    @IBAction func desaparecer(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit((Any).self)
        if(HKHealthStore.isHealthDataAvailable()) {
            let healthStore = HKHealthStore()
            let allTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!,
                                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])
            healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                if !success {
                        // Error
                }
                
            }
            loadAndDisplayMostRecentDistance()
            loadAndDisplayMostRecentHeartRate()
            
        }
        // Do any additional setup after loading the view.
    }
    
    private func loadAndDisplayMostRecentHeartRate() {
        
        //1. Use HealthKit to create the Height Sample Type
        guard let heartRateSampleType = HKSampleType.quantityType(forIdentifier: .heartRate) else {
            print("Heart Rate Sample Type is no longer available in HealthKit")
            return
        }
        
        ProfileDataStore.getMostRecentSample(for: heartRateSampleType) { (sample, error) in
            
            guard let sample = sample else {
                
                if let error = error {
                    // self.displayAlert(for: error)
                }
                
                return
            }
            
            //2. Convert the height sample to meters, save to the profile model,
            //   and update the user interface.
            let heartRateInBPM = Int(sample.quantity.doubleValue(for: HKUnit(from: "count/min")))
            self.userHealthProfile.heartRate = heartRateInBPM
            self.updateLabels()
        }
    }
    
    private func loadAndDisplayMostRecentDistance() {
        
        //1. Use HealthKit to create the Height Sample Type
        guard let distanceSampleType = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            print("Distance Walking Running Sample Type is no longer available in HealthKit")
            return
        }
        
        ProfileDataStore.getMostRecentSample(for: distanceSampleType) { (sample, error) in
            
            guard let sample = sample else {
                
                if let error = error {
                   // self.displayAlert(for: error)
                }
                
                return
            }
            
            //2. Convert the height sample to meters, save to the profile model,
            //   and update the user interface.
            let distanceInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
            self.userHealthProfile.distance = distanceInMeters
            self.updateLabels()
        }
    }
    
    private func updateLabels() {
        
        if let heartRate = userHealthProfile.heartRate {
            heartRateLabel.text = "\(heartRate)"
        }
        
        if let distance = userHealthProfile.distance {
            let lengthFormatter = LengthFormatter()
            lengthFormatter.isForPersonHeightUse = false
            distanceLabel.text = lengthFormatter.string(fromMeters: distance)
        }
    }
    
    private func displayAlert(for error: Error) {
        
        let alert = UIAlertController(title: nil,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "O.K.",
                                      style: .default,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
*/
