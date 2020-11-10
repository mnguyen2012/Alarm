//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Michael Nguyen on 11/9/20.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    //MARK: - Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }

    
    //MARK: - Actions
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.switchCellSwitchValueChanged(cell: self)
    }
    
    func updateViews() {
        guard let alarm = alarm else { return }
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
        
    }
    
    

}//End of Class
