//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

//Creating a Protocol delegate
//Passing the two methods
protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel )
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    //Set property of delegate to call in the ViewController
    var delegate: CoinManagerDelegate?
    
    // A)Construct the URL
    
    //Get current selected currency coming from didSelectRow pickerView func
    //Then we call the performRequest method to pass the url
    func getCoinPrice(for currency: String)  {
        
        //URL format per docs https://apiv2.bitcoinaverage.com/#price-symbols-ticker
        let urlString = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(currency)"
        
        //Invoke performRequest to pass URL
        performRequest(with: urlString)
    }
    
    // B)Perform the request, This could have been done in the getCoinPrice
    //but for organization will do a separate func
    
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
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                if let safeData = data {
//                    parseJSON is a method created below this FUNC
                    if let bitcoinPrice =  self.parseJSON(safeData)
                    {
                        self.delegate?.didUpdateCoin(self, coin:bitcoinPrice)
//                        print(currencyValue)
                        return
                    }
                }
            }
            //4.Start the task, is call resume
            task.resume()
        }
    }
    
     // C)Parse the JSON Data
    
    //This Method will be call by the performRequest once the data is recieve
    func parseJSON(_ data: Data) -> CoinModel? {
        
        //Creating an instance of the decoder
        let decoder = JSONDecoder()
        
        //"CoinData" is the struct and "from: data" is the data comming from performRequest()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            //This is the data we want to get which also has to match the type
            //create in the CoinData struct
            let lastPrice = decodedData.last
            
            //If we would want to return more data we can create a struct
            let coinData = CoinModel(lastPrice: lastPrice)
            //return the data
            return coinData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
