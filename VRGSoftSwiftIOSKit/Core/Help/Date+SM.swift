//
//  Date+SM.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/21/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation

public let smDateFormatter: DateFormatter = DateFormatter()

public extension SMWrapper where Base == Date {
    
    // MARK: - Relative dates from the current date
    
    static var dateTomorrow: Base? {
        return nowByAddingDays(1)
    }
    
    static var dateYesterday: Base? {
        return nowByAddingDays(-1)
    }
    
    static func nowByAddingYears(_ distance: Int) -> Base? {
        return dateFromNow(byAdding: .year, distance: distance)
    }
    
    static func nowByAddingMonths(_ distance: Int) -> Base? {
        return dateFromNow(byAdding: .month, distance: distance)
    }
    
    static func nowByAddingWeeks(_ distance: Int) -> Base? {
        return dateFromNow(byAdding: .weekOfYear, distance: distance)
    }
    
    static func nowByAddingDays(_ distance: Int) -> Base? {
        return dateFromNow(byAdding: .day, distance: distance)
    }
    
    static func nowByAddingHours(_ distance: Int) -> Base? {
        return dateFromNow(byAdding: .hour, distance: distance)
    }
    
    static func nowByAddingMinutes(_ distance: Int) -> Base? {
        return dateFromNow(byAdding: .minute, distance: distance)
    }
    
    static func dateFromNow(byAdding component: Calendar.Component, distance: Int) -> Base? {
        return Base().sm.dateByAdding(component: component, distance: distance)
    }
    
    
    // MARK: - Comparing dates
    
    func isEqualToDateIgnoringTime(_ date: Base) -> Bool {
        
        return year == date.sm.year &&
            month == date.sm.month &&
            day == date.sm.day
    }
    
    var isToday: Bool {
        return isEqualToDateIgnoringTime(Base())
    }
    
    var isTomorrow: Bool {
        
        guard let dateTomorrow = Base.sm.dateTomorrow else {
            return false
        }
        
        return isEqualToDateIgnoringTime(dateTomorrow)
    }
    
    var isYesterday: Bool {
        
        guard let dateYesterday = Base.sm.dateYesterday else {
            return false
        }
        
        return isEqualToDateIgnoringTime(dateYesterday)
    }
    
    func isSameWeekAsDate(_ date: Base) -> Bool {
        return weekOfYear == date.sm.weekOfYear
    }
    
    var isThisWeek: Bool {
        return isSameWeekAsDate(Base())
    }
    
    var isNextWeek: Bool {
        
        guard let newDate = Base().sm.dateByAddingWeeks(1) else {
            return false
        }
        
        return isSameWeekAsDate(newDate)
    }
    
    var isLastWeek: Bool {
        
        guard let newDate = Base().sm.dateByAddingWeeks(-1) else {
            return false
        }
        
        return isSameWeekAsDate(newDate)
    }
    
    func isSameYearAsDate(_ date: Base) -> Bool {
        return year == date.sm.year
    }
    
    var isThisYear: Bool {
        return isSameYearAsDate(Base())
    }
    
    var isNextYear: Bool {
        return year == Base().sm.year + 1
    }
    
    var isLastYear: Bool {
        return year == Base().sm.year - 1
    }
    
    func isEarlierThanDate(_ date: Base) -> Bool {
        return self.base < date
    }
    
    func isLaterThanDate(_ date: Base) -> Bool {
        return self.base > date
    }
    
    func isSameYearAndMonthAsDate(_ date: Base) -> Bool {
        return year == date.sm.year && month == date.sm.month
    }
    
    
    // MARK: - Adjusting dates
    
    func dateByAddingYears(_ distance: Int) -> Base? {
        return dateByAdding(component: .year, distance: distance)
    }
    
    func dateByAddingMonths(_ distance: Int) -> Base? {
        return dateByAdding(component: .month, distance: distance)
    }
    
    func dateByAddingWeeks(_ distance: Int) -> Base? {
        return dateByAdding(component: .weekOfYear, distance: distance)
    }
    
    func dateByAddingDays(_ distance: Int) -> Base? {
        return dateByAdding(component: .day, distance: distance)
    }
    
    func dateByAddingHours(_ distance: Int) -> Base? {
        return dateByAdding(component: .hour, distance: distance)
    }
    
    func dateByAddingMinutes(_ distance: Int) -> Base? {
        return dateByAdding(component: .minute, distance: distance)
    }
    
    func dateByAdding(component: Calendar.Component, distance: Int) -> Base? {
        return Calendar.current.date(byAdding: component, value: distance, to: self.base)
    }
    
    var dateAtStartOfDay: Base {
        return Calendar.current.startOfDay(for: self.base)
    }
    
    
    // MARK: - Retrieving intervals
    
    static func yearsToNowFrom(_ date: Base) -> Int? {
        return distanceFromNow(to: date, with: .year)
    }
    
    static func monthsToNowFrom(_ date: Base) -> Int? {
        return distanceFromNow(to: date, with: .month)
    }
    
    static func weeksToNowFrom(_ date: Base) -> Int? {
        return distanceFromNow(to: date, with: .weekOfYear)
    }
    
    static func daysToNowFrom(_ date: Base) -> Int? {
        return distanceFromNow(to: date, with: .day)
    }
    
    static func hoursToNowFrom(_ date: Base) -> Int? {
        return distanceFromNow(to: date, with: .hour)
    }
    
    static func minutesToNowFrom(_ date: Base) -> Int? {
        return distanceFromNow(to: date, with: .minute)
    }

    static func distanceFromNow(to date: Base, with component: Calendar.Component) -> Int? {
        return Base().sm.distanceTo(date, with: component)
    }
    
    func yearsTo(_ date: Base) -> Int? {
        return distanceTo(date, with: .year)
    }
    
    func monthsTo(_ date: Base) -> Int? {
        return distanceTo(date, with: .month)
    }
    
    func weeksTo(_ date: Base) -> Int? {
        return distanceTo(date, with: .weekOfYear)
    }
    
    func daysTo(_ date: Base) -> Int? {
        return distanceTo(date, with: .day)
    }
    
    func hoursTo(_ date: Base) -> Int? {
        return distanceTo(date, with: .hour)
    }
    
    func minutesTo(_ date: Base) -> Int? {
        return distanceTo(date, with: .minute)
    }
    
    func distanceTo(_ date: Base, with component: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([component], from: self.base, to: date).value(for: component)
    }
    
    
    // MARK: - Decomposing dates
    
    var nearestHour: Int {
        return Calendar.current.component(.hour, from: self.base)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self.base)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self.base)
    }
    
    var seconds: Int {
        return Calendar.current.component(.second, from: self.base)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self.base)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self.base)
    }
    
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self.base)
    }
    
    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self.base)
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self.base)
    }
    
    var weekdayOrdinal: Int {
        return Calendar.current.component(.weekdayOrdinal, from: self.base)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self.base)
    }
    
    
    // MARK: - Converting
    
    static func convertString(_ dateStr: String, toDateWithFormat format: String, locale: Locale = Locale.current, timeZone: TimeZone = TimeZone.current) -> Base? {
        
        var result: Base?
        
        smDateFormatter.locale = locale
        smDateFormatter.timeZone = timeZone
        smDateFormatter.dateFormat = format
        result = smDateFormatter.date(from: dateStr)
        
        return result
        
    }
    static func convertDate(_ date: Base, toStringWithFormat format: String, locale: Locale = Locale.current, timeZone: TimeZone = TimeZone.current) -> String {
        
        var result: String
        
        smDateFormatter.locale = locale
        smDateFormatter.timeZone = timeZone
        smDateFormatter.dateFormat = format
        result = smDateFormatter.string(from: date)
        
        return result
    }
}


extension Date: SMCompatible { }
