//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

//Adding the UIPickerViewDataSource protocol for the currency picker
//Adding UIPickerViewDelegate to watch for choice option
class ViewController: UIViewController, UIPickerViewDataSource {
    
    //IBOutlet
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    //Creating instance of CoinManager
    var coinManager = CoinManager()
    
    //Current selection from picker
    var selectedCurrency = "USD"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set class as delegate for CoinManagerDelegate
        coinManager.delegate = self
        
        //set as data source for currency picker to display options
        currencyPicker.dataSource = self
        
        //set as delegate for currency picker activity
        currencyPicker.delegate = self
    }
}

//MARK: - CoinManagerDelegate

//Creating extension of ViewController to include CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = coin.lastToString
            self.currencyLabel.text = self.selectedCurrency
            //            print("Triggered", coin.lastToString)
        }
    }
    
    func didFailWithError(error: Error) {
        print("Error:", error)
    }
}


//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    
    //1st method for the UIPickerViewDataSource protocol for columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //this is how many columns to return in the picker
        //Each calum acts as a separate picker
        return 1
    }
    
    //2nd method for the UIPickerViewDataSource protocol to create rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //Instead of hard couding how many currency options we have
        //to create the correct ammount of rows we simply count it as shuch:
        return coinManager.currencyArray.count
    }
    
    //1st for UIPickerViewDelegate to actually render the values in the array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    //2nd This method checks which option is currently selected in the picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
    
}
