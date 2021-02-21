//
//  TimeInterval.swift
//  Trendz Music
//
//  Created by Girira Stephy on 21/02/21.
//

import Foundation


func getMinutesFromMS(value: Double) -> String{
    
    let seconds = value / 1000
    var minutes = seconds / 60
    minutes = minutes.truncatingRemainder(dividingBy: 60).nextUp.rounded()
    let valueOfMin = "\(Int(minutes)) min"
    return valueOfMin
}
