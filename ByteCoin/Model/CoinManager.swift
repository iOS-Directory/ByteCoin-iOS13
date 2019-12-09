//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    //Get current selected currency comming from didSelectRow pickerView func
    //Then we call the performRequest method to pass the url
    func getCoinPrice(for currency: String)  {
        
        //URL format per docs https://apiv2.bitcoinaverage.com/#price-symbols-ticker
        let urlString = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(currency)"
        
        //Invoke performRequest to pass URL
        performRequest(with: urlString)
    }
    
    //Creating the URL to contact API
    func performRequest(with urlString: String) {
        
        //1.Using the URL method and since is an optional we use if to unwrap it
        //This will be pass to the session task below
        if let url = URL(string: urlString){
            
            //2.Creating session
            //The URLSession class and related classes provide an API for downloading data from and uploading data to endpoints indicated by URLs.
            let session = URLSession(configuration: .default)
            
            //3.Now we access the dataTask property of session
            //To give the session a task to complete
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    //parseJSON is a method created below this FUNC
                    //                    if let currencyValue =  self.parseJSON(safeData){
                    //                        self.delegate?.didUpdateWeather(self, currencyValue:currencyValue)
                    //                        return
                    //                    }
                    
                    let backToString = String(data: safeData, encoding: String.Encoding.utf8) as String?
                    
                    print(backToString!)
                }
            }
            //4.Start the task, is call resume
            task.resume()
        }
    }
    
}
