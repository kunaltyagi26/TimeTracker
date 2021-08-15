//
//  TimeTableInterfaceController.swift
//  TimeTracker WatchKit Extension
//
//  Created by Kunal Tyagi on 15/08/21.
//

import Foundation
import WatchKit

class TimeTableInterfaceController: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!
    
    private var clockIns = [Date]()
    private var clockOuts = [Date]()
    
    override func awake(withContext context: Any?) {
        if let clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date], let clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date] {
            self.clockIns = clockIns
            self.clockOuts = clockOuts
        }
    }
    
    override func willActivate() {
        table.setNumberOfRows(clockIns.count, withRowType: "ClockInOutRow")
        for index in 0..<clockIns.count {
            if let rowController = table.rowController(at: index) as? ClockInOutRowController {
                let timeInterval = Calendar.current.dateComponents([.hour, .minute, .second], from: clockIns[index], to: clockOuts[index])
                if let hour = timeInterval.hour, let minute = timeInterval.minute, let second = timeInterval.second {
                    var timeIntervalString = ""
                    
                    if let hour = timeInterval.hour, hour != 0 {
                        timeIntervalString += "\(hour)h "
                    }
                    if let minute = timeInterval.minute, minute != 0 || timeInterval.hour != 0 {
                        timeIntervalString += "\(minute)m "
                    }
                    if let second = timeInterval.second {
                        timeIntervalString += "\(second)s"
                    }
                    
                    rowController.label.setText(timeIntervalString)
                }
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        pushController(withName: "timeDetail", context: [clockIns[rowIndex], clockOuts[rowIndex]])
    }
}
