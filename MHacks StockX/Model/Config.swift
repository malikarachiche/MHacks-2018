//
//  Config.swift
//  MHacks StockX
//
//  Created by Nikhil Iyer on 10/13/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import Foundation
import UIKit


class Config{
    
    private(set) var startDate: Date
    private(set) var endDate: Date
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func progress(for date: Date = Date()) -> Double {
        return 1.0 - self.timeRemaining(for: date) / self.duration
    }
    
    private func timeRemaining(for date: Date = Date()) -> TimeInterval {
        return self.endDate.timeIntervalSince(progressDate(for: date))
    }
    
    private func progressDate(for date: Date = Date()) -> Date {
        return min(max(date, self.startDate), endDate)
    }
    
    private var duration: TimeInterval {
        return self.endDate.timeIntervalSince1970 - self.startDate.timeIntervalSince1970
    }
    
}
