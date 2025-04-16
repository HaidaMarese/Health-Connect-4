//
//  SignUpViewController.swift
//  DoctorBookingApp
//
//  Created by Haida Makouangou on 2025-04-09.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var dobTxtField: UITextField!
    @IBOutlet weak var genderTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    func updateUI() {
        emailTxtField.layer.cornerRadius = 10
        emailTxtField.layer.borderWidth = 1
        emailTxtField.layer.borderColor = UIColor(red: 51/255, green: 67/255, blue: 88/255, alpha: 1.0).cgColor
        emailTxtField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        emailTxtField.textColor = .darkText
        emailTxtField.font = UIFont.systemFont(ofSize: 16)
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: emailTxtField.frame.height))
        emailTxtField.leftView = leftPaddingView
        
        nameTxtField.layer.cornerRadius = 10
        nameTxtField.layer.borderWidth = 1
        nameTxtField.layer.borderColor = UIColor(red: 51/255, green: 67/255, blue: 88/255, alpha: 1.0).cgColor
        nameTxtField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        nameTxtField.textColor = .darkText
        nameTxtField.font = UIFont.systemFont(ofSize: 16)
        nameTxtField.leftView = leftPaddingView
        
        phoneTxtField.layer.cornerRadius = 10
        phoneTxtField.layer.borderWidth = 1
        phoneTxtField.layer.borderColor = UIColor(red: 51/255, green: 67/255, blue: 88/255, alpha: 1.0).cgColor
        phoneTxtField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        phoneTxtField.textColor = .darkText
        phoneTxtField.font = UIFont.systemFont(ofSize: 16)
        phoneTxtField.leftView = leftPaddingView
        
        dobTxtField.layer.cornerRadius = 10
        dobTxtField.layer.borderWidth = 1
        dobTxtField.layer.borderColor = UIColor(red: 51/255, green: 67/255, blue: 88/255, alpha: 1.0).cgColor
        dobTxtField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        dobTxtField.textColor = .darkText
        dobTxtField.font = UIFont.systemFont(ofSize: 16)
        dobTxtField.leftView = leftPaddingView
        
        
        genderTxtField.layer.cornerRadius = 10
        genderTxtField.layer.borderWidth = 1
        genderTxtField.layer.borderColor = UIColor(red: 51/255, green: 67/255, blue: 88/255, alpha: 1.0).cgColor
        genderTxtField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        genderTxtField.textColor = .darkText
        genderTxtField.font = UIFont.systemFont(ofSize: 16)
        genderTxtField.leftView = leftPaddingView
        
        passwordTxtField.layer.cornerRadius = 10
        passwordTxtField.layer.borderWidth = 1
        passwordTxtField.layer.borderColor = UIColor(red: 51/255, green: 67/255, blue: 88/255, alpha: 1.0).cgColor
        passwordTxtField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        passwordTxtField.textColor = .darkText
        passwordTxtField.font = UIFont.systemFont(ofSize: 16)
        passwordTxtField.leftView = leftPaddingView
    
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
    }
}
