//
//  DetailInterfaceController.swift
//  TimeTracker WatchKit Extension
//
//  Created by Kunal Tyagi on 15/08/21.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {

    @IBOutlet weak var clockInLabel: WKInterfaceLabel!
    @IBOutlet weak var clockOutLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, EEEE, h:mma"
        
        guard let dates = context as? [Date] else { return }
        clockInLabel.setText(dateFormatter.string(from: dates[0]))
        clockOutLabel.setText(dateFormatter.string(from: dates[1]))
    }

}
