//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    var tip = 0.10
    var numberOfPeople = 2
    var billTotal = 0.0
    var finalResult = "0.0"
    
    @IBAction func tipChanged(_ sender: UIButton) {
        billTextField.endEditing(true)
        
        zeroPctButton.isSelected = false
        tenPctButton.isSelected = false
        twentyPctButton.isSelected = false
        sender.isSelected = true
        
        //현재 제목
        let buttonTitle = sender.currentTitle!
        // 제목에서 % 지우기
        let buttonTitleMinusPerSign =  String(buttonTitle.dropLast())
        //String에서 double형으로 전환
        let buttonTitleAsANumber = Double(buttonTitleMinusPerSign)!
        //소수점 계산
        tip = buttonTitleAsANumber / 100
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        //sender.value를 사용해서 stepper value 얻기.
        splitNumberLabel.text = String(format: "%.0f", sender.value)
        numberOfPeople = Int(sender.value)
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {

        let bill = billTextField.text!
        
        if bill != ""{
            billTotal = Double(bill)!
            let result = billTotal * (1 + tip) / Double(numberOfPeople)
            finalResult = String(format: "%.2f", result)
            
        }
            self.performSegue(withIdentifier: "goToResults", sender: self)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToResults"{
                
                let destinationVC = segue.destination as! ResultsViewController
                destinationVC.result = finalResult
                destinationVC.tip = Int(tip * 100)
                destinationVC.split = numberOfPeople
                
            }
        
        
    }
    
}

