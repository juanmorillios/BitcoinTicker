//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Juan Morillo on 11/8/17.
//  Copyright © 2017 Juan Morillo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var currencySelected = ""
    var finalURL = ""
    
    //IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet var labelBid: UILabel!
    @IBOutlet var labelHigh: UILabel!
    @IBOutlet var labelLast: UILabel!
    @IBOutlet var labelLow: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
    }
    
    //TODO: UIPickerView delegate methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // print(currencyArray[row])
        currencySelected = currencySymbolArray[row]
        finalURL = baseURL + currencyArray[row]
        getBitcoinData(url: finalURL)
        
    }
    
    //MARK: - Networking
    /***************************************************************/
    func getBitcoinData(url: String) {
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Sucess! Got the Bitcoin data!")
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    self.updateBitcoinJSONData(json: bitcoinJSON)
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                    self.labelLast.text = "Last = 0"
                    self.labelHigh.text = "High = 0"
                    self.labelLow.text = "Low = 0"
                    self.labelBid.text = "Bid =0"
                }
        }
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinJSONData(json : JSON) {
        
        if let bitcoinResult = json["ask"].double {
            bitcoinPriceLabel.text = "\(currencySelected)\(bitcoinResult)"
        }
        
        if let bidResult = json["bid"].double {
            labelBid.text = "\(currencySelected)\(bidResult)"
        }
        
        if let lastResult = json["last"].double {
            labelLast.text = "\(currencySelected) \(lastResult)"
        }
        
        if let highResult = json["high"].double {
            labelHigh.text = "\(currencySelected) \(highResult)"
        }
        
        if let lowResult = json["low"].double {
            labelLow.text = "\(currencySelected) \(lowResult)"
            
        }
        else {
            bitcoinPriceLabel.text = "Price Unavailable"
            labelLast.text = "0"
            labelHigh.text = "0"
            labelLow.text = "0"
            labelBid.text = "0"
        }
        
    }
    
}

