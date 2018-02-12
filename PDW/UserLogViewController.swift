//
//  UserLogViewController.swift
//  PDW
//
//  Created by Sanjin on 06/02/2017.
//  Copyright © 2017 Sanjin. All rights reserved.
//

import UIKit
import os.log

class UserLogViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fluidTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var fluidUnit: UISegmentedControl!
    
    var userLog: UserLog?
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())

        fluidTextField.delegate = self
        
        updateSaveButtonState()
        loadDefaults()
        
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(UserLogViewController.doneButtonAction))
        //array of BarButtonItems
        var arr = [UIBarButtonItem]()
        arr.append(flexSpace)
        arr.append(doneBtn)
        toolbar.setItems(arr, animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.fluidTextField.inputAccessoryView = toolbar

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    internal func textField(_ shouldChangeCharactersIntextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        
        let components = string.components(separatedBy: inverseSet)
        
        let filtered = components.joined(separator: ".")
        
        return (string as NSString) as String == filtered
        
        
    }

    
    // MARK: - Navigation
     
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
     

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let fluid = fluidTextField.text ?? ""
       // let note = DateFormatter()
       // note.dateFormat = "dd/MM/yyyy"
        let date = datePicker.date
        let inputDate = NSDate()
        let unit = fluidUnit.selectedSegmentIndex
        userLog = UserLog(fluid: fluid, date: date, inputDate: inputDate as Date, unit: unit)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    @IBAction func saveState(_ sender: UISegmentedControl) {
        if fluidUnit.selectedSegmentIndex == 0 {
            defaults.set(fluidUnit.selectedSegmentIndex, forKey: "selectedUnit")
        }
        if fluidUnit.selectedSegmentIndex == 1 {
            defaults.set(fluidUnit.selectedSegmentIndex, forKey: "selectedUnit")
        }
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = fluidTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        let segment = UISegmentedControlNoSegment as Int
        let segmentStr : Int = segment
        let segment2 = String(segmentStr)
        saveButton.isEnabled = !segment2.isEmpty
    }
    func loadDefaults() {
    let defaults = UserDefaults.standard
    fluidUnit.selectedSegmentIndex = defaults.integer(forKey: "selectedUnit")
    }
}
