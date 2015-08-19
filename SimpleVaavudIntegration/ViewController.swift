//
//  ViewController.swift
//  SimpleVaavudIntegration
//
//  Created by Gustaf Kugelberg on 19/08/15.
//  Copyright (c) 2015 Vaavud. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var windLabel: UILabel!
    
    @IBAction func measureWindTapped(sender: UIButton) {
        measureWind()
    }
    
    func measureWind() {
        let components = NSURLComponents()
        components.scheme = "vaavud"
        components.host = "x-callback-url"
        components.path = "/measure"
        components.queryItems = [NSURLQueryItem(name: "x-success", value: "mysimpleapp://x-callback-url/measurement")]
        
        if let url = components.URL {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func displayMessage(string: String) {
        windLabel.text = string
    }
}