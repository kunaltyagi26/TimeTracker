//
//  InterfaceController.swift
//  TimeTracker WatchKit Extension
//
//  Created by Kunal Tyagi on 09/08/21.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var topLabel: WKInterfaceLabel!
    @IBOutlet weak var middleLabel: WKInterfaceLabel!
    @IBOutlet weak var button: WKInterfaceButton!
    
    private var isClockedIn = false {
        didSet {
            self.topLabel.setHidden(!self.isClockedIn)
            self.topLabel.setText("Today: \(self.totalTimeWorkedAsString())")
            self.middleLabel.setText(isClockedIn ? "\(getClockedInTimeIntervalFromDate())" : "Today \n\(totalTimeWorkedAsString())")
            self.button.setTitle(self.isClockedIn ? "Clock-Out" : "Clock-In")
            self.button.setBackgroundColor(self.isClockedIn ? #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1) : #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1))
        }
    }
    
    private var timer: Timer?
    
    override func willActivate() {
        if let _ = UserDefaults.standard.value(forKey: "clockedIn") {
            isClockedIn = true
            if timer == nil {
                startTimer()
            }
        } else {
            isClockedIn = false
        }
    }

    @IBAction func clockInOutTapped() {
        isClockedIn ? clockOut() : clockIn()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.middleLabel.setText(self.getClockedInTimeIntervalFromDate())
            self.topLabel.setText("Today: \(self.totalTimeWorkedAsString())")
        }
    }
    
    func getClockedInTimeIntervalFromDate()-> String {
        var timeIntervalString = ""
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
            let timeInterval = Calendar.current.dateComponents([.hour, .minute, .second], from: clockedInDate, to: Date())
            if let hour = timeInterval.hour, hour != 0 {
                timeIntervalString += "\(hour)h "
            }
            if let minute = timeInterval.minute, minute != 0 || timeInterval.hour != 0 {
                timeIntervalString += "\(minute)m "
            }
            if let second = timeInterval.second {
                timeIntervalString += "\(second)s"
            }
        } else {
            timeIntervalString = "0s"
        }
        return timeIntervalString
    }
    
    func clockIn() {
        isClockedIn = true
        UserDefaults.standard.set(Date(), forKey: "clockedIn")
        
        startTimer()
    }
    
    func clockOut() {
        isClockedIn = false
        timer?.invalidate()
        timer = nil
        
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
            if var clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date] {
                clockIns.insert(clockedInDate, at: 0)
                UserDefaults.standard.set(clockIns, forKey: "clockIns")
            } else {
                UserDefaults.standard.set([clockedInDate], forKey: "clockIns")
            }
            
            if var clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date] {
                clockOuts.insert(Date(), at: 0)
                UserDefaults.standard.set(clockOuts, forKey: "clockOuts")
            } else {
                UserDefaults.standard.set([Date()], forKey: "clockOuts")
            }
            
            UserDefaults.standard.set(nil, forKey: "clockedIn")
        }
    }
    
    func totalClockedTime()-> DateComponents {
        var totalTimeInterval = DateComponents()
        if let clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date], let clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date], clockIns.count == clockOuts.count {
            
            for index in 0..<clockIns.count {
                let timeInterval = Calendar.current.dateComponents([.hour, .minute, .second], from: clockIns[index], to: clockOuts[index])
                totalTimeInterval  = totalTimeInterval + timeInterval
            }
        }
        return totalTimeInterval
    }
    
    func totalTimeWorkedAsString()-> String {
        var timeInterval = DateComponents()
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
            timeInterval = Calendar.current.dateComponents([.hour, .minute, .second], from: clockedInDate, to: Date())
        }
        
        let totalTimeInterval = timeInterval + self.totalClockedTime()
        if let hour = totalTimeInterval.hour, let minute = totalTimeInterval.minute {
            return "\(hour)h \(minute)m"
        }
        
        return ""
    }
    
    @IBAction func historyTapped() {
        pushController(withName: "timeTableController", context: nil)
    }
    
    @IBAction func resetAllTapped() {
        UserDefaults.standard.set(nil, forKey: "clockedIn")
        UserDefaults.standard.set(nil, forKey: "clockIns")
        UserDefaults.standard.set(nil, forKey: "clockOuts")
        
        isClockedIn = false
    }
}
