//
//  Alarm.swift
//  Alarm
//
//  Created by Michael Nguyen on 11/9/20.
//

import Foundation

class Alarm: Codable {
    var name: String
    var fireDate: Date
    var enabled: Bool
    var uuid: String
    var fireTimeAsString: String {
        
    
    let formatter = DateFormatter()
    formatter.dateFormat = "HH.mm E, d MMM, y"
    return (formatter.string(from: fireDate))
    }
    init(name: String, fireDate: Date, enabled: Bool, uuid: String = UUID().uuidString) {
        self.name = name
        self.fireDate = fireDate
        self.enabled = enabled
        self.uuid = uuid
    }
}//End of Class

extension Alarm: Equatable{
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}


