//
//  ViewController.swift
//  BankIdentifyNumberChecker
//
//  Created by Furkan Ceylan on 6.07.2022.

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var binTextField: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var schemeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var binLabel: UILabel!
    
    let myApi = myApiKey()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func checkButtonClicked(_ sender: Any) {
        
        if binTextField.text != ""{
            if let bin = binTextField.text{
                var semaphore = DispatchSemaphore (value: 0)
                let key = myApi.myApi()
                let url = "https://api.apilayer.com/bincheck/\(bin)"
                
                var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
                request.httpMethod = "GET"
                request.addValue("\(key)", forHTTPHeaderField: "apikey")
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if error != nil{
                        self.alertMessage(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error, try again.")
                    }else{
                        if data != nil{
                            do{
                                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                                
                                DispatchQueue.main.async {
                                    print(jsonResponse)
                                    if let country = jsonResponse["country"] as? String{
                                        self.countryLabel.text = "Country : \(country)"
                                    }
                                    
                                    if let scheme = jsonResponse["scheme"] as? String{
                                        self.schemeLabel.text = "Scheme : \(scheme)"
                                    }
                                    
                                    if let type = jsonResponse["type"] as? String{
                                        self.typeLabel.text = "Type : \(type)"
                                    }
                                    
                                    if let bankName = jsonResponse["bank_name"] as? String{
                                        self.bankNameLabel.text = "Bank Name : \(bankName)"
                                    }
                                    
                                    if let bin = jsonResponse["bin"] as? String{
                                        self.binLabel.text = "Bank Identify Number : \(bin)"
                                    }
                                }
                            }catch{
                                self.alertMessage(titleInput: "Error", messageInput: error.localizedDescription)
                            }
                        }
                    }
                
                semaphore.wait()
                }
                task.resume()
            }
        }else{
            alertMessage(titleInput: "Warning", messageInput: "Bank Identify Number cannot be left blank !")
        }
        
    }
    
    @objc func alertMessage(titleInput : String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

