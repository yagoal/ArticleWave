//
//  DateFormatter+Extension.swift
//  ArticleWave
//
//  Created by Yago Pereira on 12/5/24.
//

import Foundation

extension DateFormatter {
    static func string(fromISO isoDate: String, to format: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

        guard let date = isoFormatter.date(from: isoDate) else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = format

        return dateFormatter.string(from: date)
    }
}
