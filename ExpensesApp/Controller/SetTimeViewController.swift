//
//  SetTimeViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 04/05/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

protocol SetTimeDelegate {
    func didSelectTime(date: Date)
}

class SetTimeViewController: UIViewController {
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var setTimeLabel: UILabel!
    @IBOutlet weak var setDateLabel: UILabel!
    @IBOutlet weak var customDateContainerView: UIView!
    @IBOutlet weak var customDateSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: SetTimeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimeLabel.text = "Use current time".localized()
        setDateLabel.text = "Set the date".localized()
        titleLabel.text = "Custom Date".localized()
        doneBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        doneBtn.setTitle("DONE".localized(), for: .normal)
    }
    
    @IBAction func customDateSwitchToggle(_ sender: UISwitch) {
        customDateContainerView.isHidden = customDateSwitch.isOn
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        if customDateSwitch.isOn {
            delegate?.didSelectTime(date: Date())
            dismiss(animated: true, completion: nil)
        } else {
            delegate?.didSelectTime(date: datePicker.date)
            dismiss(animated: true, completion: nil)
        }
    }
    
}
