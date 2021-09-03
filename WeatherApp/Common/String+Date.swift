//
//  String+Date.swift
//  WeatherApp
//
//  Created by Arda Onat on 24.08.2021.
//

import Foundation

extension String {
    func dayFromString() -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        guard let date = dateFormatter.date(from: self) else { return nil }
        
        let  components = Calendar.current.dateComponents([.day], from: date)
        
        guard let day = components.day else { return nil }
        return day
    }
}
