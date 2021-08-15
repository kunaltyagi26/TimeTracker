//
//  DateComponents+Extension.swift
//  TimeTracker WatchKit Extension
//
//  Created by Kunal Tyagi on 15/08/21.
//

import Foundation

extension DateComponents {
    static func +(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
      return combineComponents(lhs, rhs)
    }

    static func -(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
      return combineComponents(lhs, rhs, multiplier: -1)
    }

    static func combineComponents(_ lhs: DateComponents,
                           _ rhs: DateComponents,
                           multiplier: Int = 1)
      -> DateComponents {
        var result = DateComponents()
        result.nanosecond = (lhs.nanosecond ?? 0) + (rhs.nanosecond ?? 0) * multiplier
        result.second     = (lhs.second     ?? 0) + (rhs.second     ?? 0) * multiplier
        result.minute     = (lhs.minute     ?? 0) + (rhs.minute     ?? 0) * multiplier
        result.hour       = (lhs.hour       ?? 0) + (rhs.hour       ?? 0) * multiplier
        result.day        = (lhs.day        ?? 0) + (rhs.day        ?? 0) * multiplier
        result.weekOfYear = (lhs.weekOfYear ?? 0) + (rhs.weekOfYear ?? 0) * multiplier
        result.month      = (lhs.month      ?? 0) + (rhs.month      ?? 0) * multiplier
        result.year       = (lhs.year       ?? 0) + (rhs.year       ?? 0) * multiplier
        return result
    }
}
