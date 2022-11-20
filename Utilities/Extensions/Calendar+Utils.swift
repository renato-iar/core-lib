import Foundation

public extension Calendar {
    func date(from year: Int, month: Int, day: Int, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date? {
        return self.date(from: .init(calendar: self,
                                     timeZone: nil,
                                     era: nil,
                                     year: year,
                                     month: month,
                                     day: day,
                                     hour: hour,
                                     minute: minute,
                                     second: second,
                                     nanosecond: nil,
                                     weekday: nil,
                                     weekdayOrdinal: nil,
                                     quarter: nil,
                                     weekOfMonth: nil,
                                     weekOfYear: nil,
                                     yearForWeekOfYear: nil))
    }
}
