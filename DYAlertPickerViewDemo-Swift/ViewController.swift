//
//  ViewController.swift
//  DYAlertPickerViewDemo-Swift
//
//  Created by danny on 2016/1/7.
//  Copyright © 2016年 danny. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DYAlertPickViewDelegate, DYAlertPickViewDataSource {
    var items = Array<String>()
    var alertView:DYAlertPickView = DYAlertPickView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func pickerview(pickerView: DYAlertPickView!, titleForRow row: Int) -> NSAttributedString! {
        let str = NSAttributedString(string: items[row])
        return str
    }
    func numberOfRowsInPickerview(pickerView: DYAlertPickView!) -> Int {
        return items.count
    }
    
    
    func pickerview(pickerView: DYAlertPickView!, didConfirmWithItemAtRow row: Int) {
        print(items[row]," didConfirm");
    }
    
    func pickerviewDidClickCancelButton(pickerView: DYAlertPickView!) {
        print("Canceled");
    }
    
    func pickerviewDidClickSwitchButton(pickerView: DYAlertPickView!, switchButton: UISwitch!) {
        if (switchButton.on) {
            print("On")
        }else {
            print("Off")
        }
    }
    
    @objc func alertpickerviewStateOfSwitchButton() -> Bool {
        return true;
    }
    
    func showAlertPickerView(sender:UIButton ) {
        self.alertView = DYAlertPickView(headerTitle: "Title", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm", switchButtonTitle: "Don't ask me")
        self.alertView.delegate = self;
        self.alertView.dataSource = self;
        items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
        self.alertView.showAndSelectedIndex(3)
    }
}

