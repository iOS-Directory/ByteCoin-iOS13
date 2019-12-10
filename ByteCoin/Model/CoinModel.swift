//
//  CoinModel.swift
//  ByteCoin
//
//  Created by FGT MAC on 12/9/19.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

//Here we are basically creating a struct to centralized the values
//comming from the API after parsing them
struct CoinModel {
    let lastPrice: Double
    
    //Computed property to convert Double to stirng
    var lastToString: String{
        return String(format: "%.2f", lastPrice)
    }
}
