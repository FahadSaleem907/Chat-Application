import Foundation
import UIKit

extension Date
{
    func years(sinceDate: Date) -> Int?
    {
        let years = Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
        
        return years!
    }
    
    func months(sinceDate: Date) -> Int?
    {
        let months = Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
        
        return months!
    }
    
    func days(sinceDate: Date) -> Int?
    {
        let days = Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
        return days!
    }
    
    func hours(sinceDate: Date) -> Int?
    {
        let hours = Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
        
        return hours!
    }
    
    func minutes(sinceDate: Date) -> Int?
    {
        let minutes = Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
        
        return minutes!
    }
    
    func seconds(sinceDate: Date) -> Int?
    {
        let seconds = Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
        
        return seconds!
    }
    
    func daysInMonth(_ monthNumber: Int? = nil, _ year: Int? = nil) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year ?? Calendar.current.component(.year,  from: self)
        dateComponents.month = monthNumber ?? Calendar.current.component(.month,  from: self)
        if
            let d = Calendar.current.date(from: dateComponents),
            let interval = Calendar.current.dateInterval(of: .month, for: d),
            let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day
        { return days } else { return -1 }
    }
}
