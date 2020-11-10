//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Michael Nguyen on 11/9/20.
//

import UIKit

class AlarmListTableViewController: UITableViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        AlarmController.sharedInstance.loadFromPersistence()
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.sharedInstance.alarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell else { return UITableViewCell()}

        let alarmToDisplay = AlarmController.sharedInstance.alarms[indexPath.row]
        cell.alarm = alarmToDisplay

        cell.delegate = self
        return cell
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarmToDelete = AlarmController.sharedInstance.alarms[indexPath.row]
            AlarmController.sharedInstance.deleteAlarm(alarm: alarmToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let destinationVC = segue.destination as? AlarmDetailTableViewController else { return }
                let alarmToSend = AlarmController.sharedInstance.alarms[indexPath.row]
                destinationVC.alarm = alarmToSend
            }
        }
    }
}//End of Class


//MARK: - Extension
extension AlarmListTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        AlarmController.sharedInstance.toggleEnabled(for: alarm)
        tableView.reloadData()
    }

}
