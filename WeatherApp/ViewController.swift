//
//  ViewController.swift
//  WeatherApp
//
//  Created by Im100ruv on 16/02/18.
//  Copyright © 2018 Im100ruv. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func knowWeather(_ sender: Any) {
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + cityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                var weatherMessage = ""
                
                if let error = error {
                    print(error)
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        var stringSeparator = "3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                        if let contentArray = dataString?.components(separatedBy: stringSeparator){
                            if contentArray.count > 1 {
                                stringSeparator = "</span>"
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                if newContentArray.count > 1 {
                                    weatherMessage = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    print(weatherMessage)
                                }
                            }
                        }
                    }
                }
                if weatherMessage == "" {
                    weatherMessage = "The weather there couldn't found. Please try again."
                }
                DispatchQueue.main.sync(execute: {
                    self.resultLabel.text = weatherMessage
                })
            }
            
            task.resume()
        } else {
            resultLabel.text = "Invalid input. Please try again."
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()
        return true
    }

}

