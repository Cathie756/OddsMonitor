//
//  DateUtils.swift
//  OddsMonitor
//
//  Created by Chia-Yun Lee on 2025/10/19.
//

import Foundation

class DateUtils {
    static let isoDateFormatter = ISO8601DateFormatter()

    static func isoStringToDate(_ isoString: String) -> Date? {
        return isoDateFormatter.date(from: isoString)
    }
}

extension Date {
    func toIsoString() -> String {
        return DateUtils.isoDateFormatter.string(from: self)
    }

    func toReadableString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: self)
    }
}

