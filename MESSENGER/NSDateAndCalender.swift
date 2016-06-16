//
//  NSDateAndCalender.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 6/13/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    
    static func friendlyStringForDate(date:NSDate) -> String {
        // Fetch the default calendar
        let calendar = NSCalendar.currentCalendar()
        
        // Compute components from target date
        let from = calendar.components([.Day, .Month, .Year], fromDate: date)
        
        // Compute components from current date
        let to = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        
        // Compute days difference between the two
        let delta = calendar.components(.Day, fromDateComponents: from, toDateComponents: to, options: [])
        
        switch delta.day {
        case 0:
            let formatter = NSDateFormatter()
            formatter.timeZone = NSTimeZone.defaultTimeZone()
            formatter.dateFormat = "h:mm a"
            return formatter.stringFromDate(date)
            
        case 1:
            return "Yesterday"
            
        case 2..<7:
            let formatter = NSDateFormatter()
            formatter.timeStyle = .NoStyle
            formatter.dateFormat = "EEEE"
            return formatter.stringFromDate(date)
            
        default:
            let formatter = NSDateFormatter()
            formatter.timeStyle = .NoStyle
            formatter.dateFormat = "MM/dd/YY"
            return formatter.stringFromDate(date)
        }
    }
}