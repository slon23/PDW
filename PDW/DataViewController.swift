//
//  DataViewController.swift
//  PDW
//
//  Created by Sanjin on 21/01/2017.
//  Copyright © 2017 Sanjin. All rights reserved.
//

import UIKit
//import HealthKit
import os.log
import GoogleMobileAds

class DataViewController: UIViewController, UITextFieldDelegate {
    
   // let healthStore = HKHealthStore()
    //let healthManager:HealthManager = HealthManager()
    //var weight: HKQuantitySample?

    let defaults = UserDefaults.standard
    var glassSizes: Double?
    var glassSizesOz: Double?
    var fluidIntakes: String = ""
    var fluidData: String = ""
    var glassesData: String = ""
    var glassSize: String = ""

    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var unitControl: UISegmentedControl!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var glassLabel: UILabel!
    @IBOutlet weak var fluidLabel: UILabel!
    @IBOutlet weak var glassSegment: UISegmentedControl!
    @IBOutlet weak var drinkGlassLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if HKHealthStore.isHealthDataAvailable() { getHealthKitPermission() }
        
        weightInput.delegate = self
        
        updateSaveButtonState()
       
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(DataViewController.doneButtonAction))
        //array of BarButtonItems
        var arr = [UIBarButtonItem]()
        arr.append(flexSpace)
        arr.append(doneBtn)
        toolbar.setItems(arr, animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.weightInput.inputAccessoryView = toolbar
        
        bannerView.adUnitID = "ca-app-pub-2895958730740159/6229103220"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
      /*  if HKHealthStore.isHealthDataAvailable(){
        }
        else {
            return
        }*/
    
        loadDefaults()
        
        
    //guard HKHealthStore.isHealthDataAvailable() else { return }
    
        
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

    
    internal func textField(_ shouldChangeCharactersIntextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        
        let components = string.components(separatedBy: inverseSet)
        
        let filtered = components.joined(separator: "")
        
        return (string as NSString) as String == filtered
        
        
    }
    
   /* func getHealthKitPermission() {
        
        // Seek authorization in HealthKitManager.swift.
        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                // Get and set the user's height.
                self.setWeight()
            } else {
                if error != nil {
                    print(error!)
                }
                print("Permission denied.")
            }
        }
    }
    
    func setWeight() {
        // Create the HKSample for Height.
        let weightSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        
        // Call HealthKitManager's getSample() method to get the user's height.
        self.healthManager.getWeight(sampleType: weightSample!, completion: { (userWeight, error) -> Void in
            
            if( error != nil ) {
                print("Error: \(error?.localizedDescription)")
                return
            }
            
            var weightString = ""
            
            self.weight = userWeight as? HKQuantitySample
            
            // The height is formatted to the user's locale.
            if let kilograms = self.weight?.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo)) {
                let formatWeight = MassFormatter()
                formatWeight.isForPersonMassUse = true
                weightString = formatWeight.string(fromKilograms: kilograms)
            }
            
            // Set the label to reflect the user's weight.
           DispatchQueue.main.async(execute: { () -> Void in
                self.weightInput.text = weightString
            })
        })
        
    } */
    
    
    func doneButtonAction() -> String {
        updateSaveButtonState()
      //  let weightData = (weightInput.text! as String)
     //   let weightSave : Double = Double(weightData)!
      // healthManager.saveWeight(weightRecorded: weightSave, date: NSDate())
        self.view.endEditing(true)
        if unitControl.selectedSegmentIndex == 0 {
            print (self.unitLabel.text = "kg")
            defaults.set(unitLabel.text, forKey: "defaultUnit")
            defaults.set(unitControl.selectedSegmentIndex, forKey: "selectedState")
            if (weightInput.text?.isEmpty)!
            {
                print (fluidLabel.text = "Please input weight")
                print (drinkGlassLabel.text = "Choose glass size")
            }
            else {
                let a = (weightInput.text! as String)
                let c : Double = Double(a)!
                let b = 0.03
                var fluidString = c * b
                fluidString = (fluidString * 100).rounded() / 100
                fluidLabel.text = "\(fluidString) liters"
                let fluidIntakes : String = String(fluidString)
                if glassSegment.selectedSegmentIndex == 0 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizes = 0.1
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                    }
                if glassSegment.selectedSegmentIndex == 1 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizes = 0.15
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
                if glassSegment.selectedSegmentIndex == 2 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizes = 0.2
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
                if glassSegment.selectedSegmentIndex == 3 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizes = 0.25
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
                if glassSegment.selectedSegmentIndex == 4 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizes = 0.3
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
                return fluidIntakes
            }
           return fluidIntakes
            
        }
        if unitControl.selectedSegmentIndex == 1 {
            print (self.unitLabel.text = "lb")
            defaults.set(unitLabel.text, forKey: "defaultUnit")
            defaults.set(unitControl.selectedSegmentIndex, forKey: "selectedState")
            if (weightInput.text?.isEmpty)!
            {
                print (fluidLabel.text = "Please input weight")
                  print (drinkGlassLabel.text = "Choose glass size")
                 }
            else {
                let a = (weightInput.text! as String)
                let c : Double = Double(a)!
                let b = 0.458
                let sum = c * b
                let fluidString = Int(round(sum))
                fluidLabel.text = "\(fluidString) ounces(US)"
                let fluidIntakes : String = String(fluidString)
                if glassSegment.selectedSegmentIndex == 0 {
                defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                print(fluidIntakes)
                let glassSizesOz = 3.3814
                let c : Double = Double(fluidIntakes)!
                let e = c/glassSizesOz
                let glasses = Int(round(e))
                drinkGlassLabel.text = "or cca \(glasses) glasses"
                }
                if glassSegment.selectedSegmentIndex == 1 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizesOz = 5.0721
                    let c : Double = Double(fluidIntakes)!
                    let e = c/glassSizesOz
                    let glasses = Int(round(e))
                    drinkGlassLabel.text = "or cca \(glasses) glasses"
                }
                if glassSegment.selectedSegmentIndex == 2 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizesOz = 6.7628
                    let c : Double = Double(fluidIntakes)!
                    let e = c/glassSizesOz
                    let glasses = Int(round(e))
                    drinkGlassLabel.text = "or cca \(glasses) glasses"
                }
                if glassSegment.selectedSegmentIndex == 3 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizesOz = 8.4535
                    let c : Double = Double(fluidIntakes)!
                    let e = c/glassSizesOz
                    let glasses = Int(round(e))
                    drinkGlassLabel.text = "or cca \(glasses) glasses"
                }
                if glassSegment.selectedSegmentIndex == 4 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizesOz = 10.1442
                    let c : Double = Double(fluidIntakes)!
                    let e = c/glassSizesOz
                    let glasses = Int(round(e))
                    drinkGlassLabel.text = "or cca \(glasses) glasses"
                }
                return fluidIntakes
            }
            return fluidIntakes
        }
        // Do any additional setup after loading the view, typically from a nib.
       return fluidIntakes
        
    }


    @IBAction func weightDataChange(_ sender: UISegmentedControl) {
        updateSaveButtonState()
        if unitControl.selectedSegmentIndex == 0 {
            print (self.unitLabel.text = "kg")
            defaults.set(unitLabel.text, forKey: "defaultUnit")
            defaults.set(unitControl.selectedSegmentIndex, forKey: "selectedState")
            if (weightInput.text?.isEmpty)!
            {
                    print (fluidLabel.text = "Please input weight")
                  print (drinkGlassLabel.text = "Choose glass size")
                }
            else {
                let a = (weightInput.text! as String)
                let c : Double = Double(a)!
                let b = 0.03
                var fluidString = c * b
                fluidString = (fluidString * 100).rounded() / 100
                fluidLabel.text = "\(fluidString) liters"
                let fluidIntakes : String = String(fluidString)
                if glassSegment.selectedSegmentIndex == 0 {
                    defaults.set(0.1, forKey: "glassVolume")
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizes = 0.1
                    let glassSize = "0.1"
                    defaults.set(glassSize, forKey: "glassVolumeData")
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
                if glassSegment.selectedSegmentIndex == 1 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    defaults.set(0.15, forKey: "glassVolume")
                    print(fluidIntakes)
                    let glassSizes = 0.15
                    let glassSize = "0.15"
                    defaults.set(glassSize, forKey: "glassVolumeData")
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
                if glassSegment.selectedSegmentIndex == 2 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    defaults.set(0.2, forKey: "glassVolume")
                    print(fluidIntakes)
                    let glassSizes = 0.2
                    let glassSize = "0.2"
                    defaults.set(glassSize, forKey: "glassVolumeData")
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
                if glassSegment.selectedSegmentIndex == 3 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    defaults.set(0.25, forKey: "glassVolume")
                    print(fluidIntakes)
                    let glassSizes = 0.25
                    let glassSize = "0.25"
                    defaults.set(glassSize, forKey: "glassVolumeData")
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
                if glassSegment.selectedSegmentIndex == 4 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    defaults.set(0.3, forKey: "glassVolume")
                    print(fluidIntakes)
                    let glassSizes = 0.3
                    let glassSize = "0.3"
                    defaults.set(glassSize, forKey: "glassVolumeData")
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
            }
            }
    
        if unitControl.selectedSegmentIndex == 1 {
            print (self.unitLabel.text = "lb")
            defaults.set(unitLabel.text, forKey: "defaultUnit")
            defaults.set(unitControl.selectedSegmentIndex, forKey: "selectedState")
             if (weightInput.text?.isEmpty)!
             {
                    print (fluidLabel.text = "Please input weight")
                  print (drinkGlassLabel.text = "Choose glass size")
                }
             else {
                let fluidIntakes = doneButtonAction()
                let a = (weightInput.text! as String)
                let c : Double = Double(a)!
                let b = 0.458
                let sum = c * b
                let d = Int(round(sum))
                fluidLabel.text = "\(d) ounces(US)"
                if glassSegment.selectedSegmentIndex == 0 {
                let glassSizesOz = 3.3814
                let c : Double = Double(fluidIntakes)!
                let e = c/glassSizesOz
                let glasses = Int(round(e))
                drinkGlassLabel.text = "or cca \(glasses) glasses"
                }
                if glassSegment.selectedSegmentIndex == 1 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizesOz = 5.0721
                    let c : Double = Double(fluidIntakes)!
                    let e = c/glassSizesOz
                    let glasses = Int(round(e))
                    drinkGlassLabel.text = "or cca \(glasses) glasses"
                }
                if glassSegment.selectedSegmentIndex == 2 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizesOz = 6.7628
                    let c : Double = Double(fluidIntakes)!
                    let e = c/glassSizesOz
                    let glasses = Int(round(e))
                    drinkGlassLabel.text = "or cca \(glasses) glasses"
                }
                if glassSegment.selectedSegmentIndex == 3 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizesOz = 8.4535
                    let c : Double = Double(fluidIntakes)!
                    let e = c/glassSizesOz
                    let glasses = Int(round(e))
                    drinkGlassLabel.text = "or cca \(glasses) glasses"
                }
                if glassSegment.selectedSegmentIndex == 4 {
                    defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
                    print(fluidIntakes)
                    let glassSizesOz = 10.1442
                    let c : Double = Double(fluidIntakes)!
                    let e = c/glassSizesOz
                    let glasses = Int(round(e))
                    drinkGlassLabel.text = "or cca \(glasses) glasses"
                }
            }
            }
        }
    // MARK: Glass size selector
    @IBAction func glassSize(_ sender: UISegmentedControl) {
        updateSaveButtonState()
        if glassSegment.selectedSegmentIndex == 0 {
            defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
            if (weightInput.text?.isEmpty)!
            {
                print (fluidLabel.text = "Please input weight")
                print (drinkGlassLabel.text = "Choose glass size")
            }
            else{
                let fluidIntakes = doneButtonAction()
                print(fluidIntakes)
                if unitControl.selectedSegmentIndex == 0 {
                    let glassSizes = 0.1
                    let glassSize = "0.1"
                    defaults.set(glassSize, forKey: "glassVolumeData")
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
                if unitControl.selectedSegmentIndex == 1
                {
                    let glassSizesOz = 3.3814
                    let c : Double = Double(fluidIntakes)!
                    let e = c/glassSizesOz
                    let glasses = Int(round(e))
                    drinkGlassLabel.text = "or cca \(glasses) glasses"
                }
                }
        }
        if glassSegment.selectedSegmentIndex == 1 {
            defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
            if (weightInput.text?.isEmpty)!
            {
                print (fluidLabel.text = "Please input weight")
                print (drinkGlassLabel.text = "Choose glass size")
            }
            else{
                let fluidIntakes = doneButtonAction()
                print(fluidIntakes)
                if unitControl.selectedSegmentIndex == 0 {
                    let glassSizes = 0.15
                    let glassSize = "0.15"
                    defaults.set(glassSize, forKey: "glassVolumeData")
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
                if unitControl.selectedSegmentIndex == 1
                {
                    let glassSizesOz = 5.0721
                    let c : Double = Double(fluidIntakes)!
                    let e = c/glassSizesOz
                    let glasses = Int(round(e))
                    drinkGlassLabel.text = "or cca \(glasses) glasses"
                }
            }
        }
        if glassSegment.selectedSegmentIndex == 2 {
            defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
            if (weightInput.text?.isEmpty)!
            {
                print (fluidLabel.text = "Please input weight")
                print (drinkGlassLabel.text = "Choose glass size")
            }
            else{
                let fluidIntakes = doneButtonAction()
                print(fluidIntakes)
                if unitControl.selectedSegmentIndex == 0 {
                    let glassSizes = 0.2
                    let glassSize = "0.2"
                    defaults.set(glassSize, forKey: "glassVolumeData")
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
                if unitControl.selectedSegmentIndex == 1
                {
                    let glassSizesOz = 6.7628
                    let c : Double = Double(fluidIntakes)!
                    let e = c/glassSizesOz
                    let glasses = Int(round(e))
                    drinkGlassLabel.text = "or cca \(glasses) glasses"
                }

            }

        }
        if glassSegment.selectedSegmentIndex == 3 {
            defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
            if (weightInput.text?.isEmpty)!
            {
                print (fluidLabel.text = "Please input weight")
                print (drinkGlassLabel.text = "Choose glass size")
            }
            else{
                let fluidIntakes = doneButtonAction()
                print(fluidIntakes)
                if unitControl.selectedSegmentIndex == 0 {
                    let glassSizes = 0.25
                    let glassSize = "0.25"
                    defaults.set(glassSize, forKey: "glassVolumeData")
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
                if unitControl.selectedSegmentIndex == 1
                {
                    let glassSizesOz = 8.4535
                    let c : Double = Double(fluidIntakes)!
                    let e = c/glassSizesOz
                    let glasses = Int(round(e))
                    drinkGlassLabel.text = "or cca \(glasses) glasses"
                }
            }

        }
        if glassSegment.selectedSegmentIndex == 4 {
            defaults.set(glassSegment.selectedSegmentIndex, forKey: "glassState")
            if (weightInput.text?.isEmpty)!
            {
                print (fluidLabel.text = "Please input weight")
                print (drinkGlassLabel.text = "Choose glass size")
            }
            else{
                let fluidIntakes = doneButtonAction()
                print(fluidIntakes)
                if unitControl.selectedSegmentIndex == 0 {
                    let glassSizes = 0.3
                    let glassSize = "0.3"
                    defaults.set(glassSize, forKey: "glassVolumeData")
                    let c : Double = Double(fluidIntakes)!
                    let glasses = c/glassSizes
                    let glass1 = Int(round(glasses))
                    drinkGlassLabel.text = "or cca \(glass1) glasses"
                }
                if unitControl.selectedSegmentIndex == 1
                {
                    let glassSizesOz = 10.1442
                    let c : Double = Double(fluidIntakes)!
                    let e = c/glassSizesOz
                    let glasses = Int(round(e))
                    drinkGlassLabel.text = "or cca \(glasses) glasses"
                }

            }

        }
    }
    
    func notselectedSegment () {
    updateSaveButtonState()
    if glassSegment.selectedSegmentIndex == 0 {
    let glassSize = "0.1"
    defaults.set(glassSize, forKey: "glassVolumeData")
    }
    if glassSegment.selectedSegmentIndex == 1 {
    let glassSize = "0.15"
    defaults.set(glassSize, forKey: "glassVolumeData")
    }
    if glassSegment.selectedSegmentIndex == 2 {
    let glassSize = "0.2"
    defaults.set(glassSize, forKey: "glassVolumeData")
    }
    if glassSegment.selectedSegmentIndex == 3 {
    let glassSize = "0.25"
    defaults.set(glassSize, forKey: "glassVolumeData")
    }
    if glassSegment.selectedSegmentIndex == 4 {
    let glassSize = "0.3"
    defaults.set(glassSize, forKey: "glassVolumeData")
        }
    if unitControl.selectedSegmentIndex == 0 {
    defaults.set(unitControl.selectedSegmentIndex, forKey: "selectedUnit")
        }
    if unitControl.selectedSegmentIndex == 1 {
            defaults.set(unitControl.selectedSegmentIndex, forKey: "selectedUnit")
        }
    }


    // MARK: Cancel button
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Save button

    @IBAction func save(_ sender: UIBarButtonItem) {
        if (self.fluidLabel.text == "" || self.fluidLabel.text == nil) {
            dismiss(animated: true)
        }
        else {
        self.defaults.set(self.weightInput.text, forKey: "defaultWeight")
        self.defaults.set(self.fluidLabel.text, forKey: "recommendedData")
        self.defaults.set(self.drinkGlassLabel.text, forKey: "glassesLabel")
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        secondViewController.fluidData = fluidLabel.text!
        secondViewController.glassesData = drinkGlassLabel.text!
        self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func loadDefaults() {
        let defaults = UserDefaults.standard
        weightInput.text = defaults.object(forKey: "defaultWeight") as? String
        unitLabel.text = defaults.object(forKey: "defaultUnit") as? String
        unitControl.selectedSegmentIndex = defaults.integer(forKey: "selectedState")
        fluidLabel.text = defaults.object(forKey: "recommendedData") as? String
        glassSegment.selectedSegmentIndex = defaults.integer(forKey: "glassState")
        drinkGlassLabel.text = defaults.object(forKey: "glassesLabel") as? String
    }

    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = weightInput.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        if glassSegment.selectedSegmentIndex == UISegmentedControlNoSegment || unitControl.selectedSegmentIndex == UISegmentedControlNoSegment {
            saveButton.isEnabled = false
        }
    }
}
