//
//  TableViewController.swift
//  Food Diary App!
//
//  Edited by Ben Shih on 02/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//


import UIKit

class SelectPlanViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    /*Outlets and variables*/
    @IBOutlet weak var picker: UIPickerView!
    private let options = ["Standard Male","Standard Female","Customize"]
    private var selectedOption = "" // To store which plan user selected
    private let maleDefaultSet = numberOfServes().getMaleSet()
    private let femaleDefauthSet = numberOfServes().getFemaleSet()
    private let custom = numberOfServes().getCustom()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(options[row])
        selectedOption = options[row]
    }
    
    func getSelectedOption() -> [Double]
    {
        if selectedOption == "Standard Male"
        {
            return maleDefaultSet
        }else if selectedOption == "Standard Female"
        {
            return femaleDefauthSet
        }else if selectedOption == "Customize"
        {
            return custom
        }else
        {
            return maleDefaultSet
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func endEditing() {
        view.endEditing(true)
    }
}
