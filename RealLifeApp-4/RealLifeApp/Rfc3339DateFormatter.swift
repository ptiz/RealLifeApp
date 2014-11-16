//
//  Rfc3339DateFormatter.swift
//  RealLifeApp
//
//  Created by Evgenii Kamyshanov on 16.11.14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

import Foundation

class Rfc3339DateFormatter {

    private lazy var formatter:NSDateFormatter = {
        let rfc3339DateFormatter = NSDateFormatter()
        rfc3339DateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        rfc3339DateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 4*60)
        rfc3339DateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        return rfc3339DateFormatter
    }()
    
    func dateFromRfc3339(string:String) -> NSDate? {
        return self.formatter.dateFromString(string)
    }
}