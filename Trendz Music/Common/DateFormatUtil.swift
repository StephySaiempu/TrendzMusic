//
//  DateFormatUtil.swift
//  Trendz Music
//
//  Created by Girira Stephy on 21/02/21.
//

import Foundation
class DateFormatUtil
{
    private static let mFormatter = DateFormatter()
 
    static func getMonthNameAndYear(date:Date)->String
    {
        mFormatter.timeZone = TimeZone.current
        mFormatter.dateFormat = "MMM yyyy"
        return mFormatter.string(from:date)
    }
    
    static func convertStringToDate(stringDate:String) -> Date
    {
        mFormatter.dateFormat = "yyyy-MM-dd"
        mFormatter.timeZone = TimeZone.current
        return mFormatter.date(from: stringDate)!
    }
}
