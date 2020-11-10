//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Michael Nguyen on 11/9/20.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    //MARK: - Outlets
    
    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    
    @IBOutlet weak var alarmTitleTextField: UITextField!
    
    @IBOutlet weak var alarmButton: UIButton!
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    var alarmIsOn: Bool = true 
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    private func updateViews() {
        guard let alarm = alarm, isViewLoaded else { return }
        alarmDatePicker.date = alarm.fireDate
        alarmTitleTextField.text = alarm.name
        alarmIsOn = alarm.enabled
        alarmButton.setTitle(alarmIsOn ? "On" : "Off" , for: .normal)
    }
    
    //MARK: - Actions

    @IBAction func enableButtonTapped(_ sender: Any) {
        alarmIsOn.toggle()
        alarmButton.setTitle(alarmIsOn ? "On" : "Off" , for: .normal)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let alarmTitle = alarmTitleTextField.text else { return }
        if let alarm = alarm {
            AlarmController.sharedInstance.updateAlarm(alarm: alarm, fireDate: alarmDatePicker.date, name: alarmTitle, enabled: alarmIsOn)
        } else {
            AlarmController.sharedInstance.addAlarm(fireDate: alarmDatePicker.date, name: alarmTitle, enabled: alarmIsOn)
        }
        navigationController?.popViewController(animated: true)
    }
    
}//End of Class
