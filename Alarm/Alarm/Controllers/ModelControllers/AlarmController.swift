//
//  AlarmController.swift
//  Alarm
//
//  Created by Michael Nguyen on 11/9/20.
//

import UIKit

protocol AlarmScheduler: AnyObject{
}
extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Wake up!"
        content.subtitle = "It is time to get going"
        content.badge = 1
        content.sound = UNNotificationSound.default
        let date = Calendar.current.dateComponents([.day, .hour, .minute], from: alarm.fireDate)
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error)
                print(error.localizedDescription)
            } else {
                print("User will get a local notification on\(alarm.fireDate).")
            }
        }
    }
    func cancelUserNotifications(for alarm: Alarm) {
        let identifiers: [String] = {
            let identifier = alarm.uuid
            return[identifier]
        }()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
class AlarmController: Codable, AlarmScheduler {
    
    init(){
 //       self.alarms = mockAlarms
    }
    
    static let sharedInstance = AlarmController()
    
    var alarms: [Alarm] = []
    
    var mockAlarms:[Alarm] = {
        let alarmOne = Alarm(name: "Alarm 1", fireDate: Date(), enabled: true)
        let alarmTwo = Alarm(name: "Alarm 2", fireDate: Date(), enabled: true)
        let alarmThree = Alarm(name: "Alarm 3", fireDate: Date(), enabled: false)
        return[alarmOne, alarmTwo, alarmThree]
    }()
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        
        let alarm = Alarm(name: name, fireDate: fireDate, enabled: enabled)
        alarms.append(alarm)
        if enabled {
            scheduleUserNotifications(for: alarm)
        }
        saveToPersistence()
    }
    
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        if enabled {
            scheduleUserNotifications(for: alarm)
        }
        saveToPersistence()
    }
    
    func deleteAlarm(alarm: Alarm) {
        guard let alarmToDelete = alarms.firstIndex(of: alarm) else { return }
        cancelUserNotifications(for: alarm)
        alarms.remove(at: alarmToDelete)
        saveToPersistence()
    }
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled.toggle()
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
    }
    //MARK: - Persistence
    func createFileForPersistence() -> URL{
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("Alarm.json")
        return fileURL
    }
    func saveToPersistence() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonAlarm = try jsonEncoder.encode(alarms)
            try jsonAlarm.write(to: createFileForPersistence())
        } catch let encodingError {
            print("There was an error in coding the data. \(encodingError.localizedDescription)")
        }
    }
    //Load and interact with saved data
    func loadFromPersistence() {
        let jsonDecoder = JSONDecoder()
        
        do {
            let decodedAlarm = try Data(contentsOf: createFileForPersistence())
            alarms = try jsonDecoder.decode([Alarm].self, from: decodedAlarm)
            
        } catch let decodingError {
            print("There was an error decoding the data. \(decodingError.localizedDescription)")
        }
    }
}//End of Class
