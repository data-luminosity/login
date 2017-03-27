/*
 * Copyright (c) 2016-2017,  University of California, Los Angeles
 * Coded by Keshav Tadimeti
 * All rights reserved.
 *
 */

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmailInput: UITextField!
    @IBOutlet weak var userPasswordInput: UITextField!
    
    let client_id: String = "vUhmZrUQexg58VUF98V7O7sYKIOg4q1dcVc5qJsI"
    let client_secret: String = "9U4GDhgT8RN3wHLSq1oxBhKQexqR41G3lzgoGbhsQeVCgSQRSaSfR2WCOxGBGR5vF9pw5yy0OQmJe4lgxrEYXvMpx3Hzxex2UmGg7PPWgmMEAylWNFwKJ1DZjP5XEU3Q"
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(colorLiteralRed: 45/255, green: 134/255, blue: 194/255, alpha: 1)

        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        captivePortalCheck()

        // Do any additional setup after loading the view.
    }

    @IBAction func registerLink(_ sender: AnyObject) {
        if let url = URL(string: ServerHandler.getRegisterUrl()) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // if login button clicked
    @IBAction func loginButtonClicked(_ sender: AnyObject) {
        let userInput: String = userEmailInput.text!
        let passwordInput: String = userPasswordInput.text!
        
        if (userInput.isEmpty)
        {
            displayAlert("Username cannot be empty.")
            return
        }
            
        else if (passwordInput.isEmpty)
        {
            displayAlert("Password cannot be empty.")
            return
        }

        
        attemptLoginOnServer(userInput,password: passwordInput)
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // function to display alerts to screen
    fileprivate func displayAlert(_ message: String)
    {
        if #available(iOS 9.0, *) {
            let alertController: UIAlertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            
            let settingsAction: UIAlertAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
            
        else {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
            let clickOkay = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(clickOkay)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    // call back to segue back to this viewController
    @IBAction func backToLoginViewController(_ segue: UIStoryboardSegue) {
    }
    
    
    // try to log into server to see if password and username are valid
    func attemptLoginOnServer(_ username: String, password: String)
    {
        captivePortalCheck()
        print("Enter attemptLoginOnServer")
        
        let parameters = [
            "grant_type" : "password",
            "username" : username,
            "password" : password,
            "client_id": client_id,
            "client_secret": client_secret
        ]
        
        Alamofire.request(ServerHandler.getAuthUrl(), method: .post, parameters: parameters)
            .validate()
            .responseJSON
            { response in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                let json_access_token = response.object(forKey: "access_token")
                let json_refresh_token = response.object(forKey: "refresh_token")
                
                UserDefaults.standard.set(json_access_token, forKey: "access_token")
                UserDefaults.standard.set(json_refresh_token, forKey: "refresh_token")
                
                self.performSegue(withIdentifier: "returnToViewController", sender: self)
                break
            case .failure( _):
                //FIXME need callback
                self.displayAlert("Username or password is incorrect")
                break
                }
        }
        
    }

    
    func captivePortalCheck() {
        Alamofire.request(ServerHandler.getFAQUrl(), method: .get)
            .responseString { response in
                
                if response.result.error != nil {
                    let statusCode = (response.response?.statusCode)!
                    // then error occurred
                    if (statusCode/100 != 2) {
                        self.displayAlert("Unable to connect to the Internet. Are you signed in on your WiFi?")
                    }
                }
                    
                else { //no errors
                    let statusCode = (response.response?.statusCode)!
                    print("Login view: ", statusCode)
                    if (statusCode/100 != 2) {
                        self.displayAlert("Unable to connect to the Internet. Are you signed in on your WiFi?")
                    }
                }
        }
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

