//
//  ViewController.swift

//

//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var userTxtField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    
    func updateUI() {
        
        passwordTxtField.isSecureTextEntry = true
        userTxtField.layer.cornerRadius = 10
        userTxtField.layer.borderWidth = 1
        userTxtField.layer.borderColor = UIColor(red: 51/255, green: 67/255, blue: 88/255, alpha: 1.0).cgColor
        userTxtField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        userTxtField.textColor = .darkText
        userTxtField.font = UIFont.systemFont(ofSize: 16)
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: userTxtField.frame.height))
        userTxtField.leftView = leftPaddingView
        
        passwordTxtField.layer.cornerRadius = 10
        passwordTxtField.layer.borderWidth = 1
        passwordTxtField.layer.borderColor = UIColor(red: 51/255, green: 67/255, blue: 88/255, alpha: 1.0).cgColor
        passwordTxtField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        passwordTxtField.textColor = .darkText
        passwordTxtField.font = UIFont.systemFont(ofSize: 16)
        passwordTxtField.leftView = leftPaddingView
        
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        
        
                
                   guard let username = userTxtField.text, !username.isEmpty,
                         let password = passwordTxtField.text, !password.isEmpty else {
                       
                       showAlert(message: "Please enter both username and password.")
                       return
                   }
        
                   
                   authenticateUser(username: username, password: password) { success, error in
                       if success {
                           
                           UserDefaults.standard.set(username, forKey: "username")
                           UserDefaults.standard.set(true, forKey: "isLoggedIn")
        
        
                           self.navigateToTabBarController()
                       } else if let error = error {
        
                           self.showAlert(message: error.localizedDescription)
                       }
                   }
    }
    
    
    
    func authenticateUser(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(true, nil)
            if username == "validUser" && password == "validPassword" {
                completion(true, nil)
            } else {
                completion(false, NSError(domain: "LoginError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"]))
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    func navigateToTabBarController() {
        
        let tabBarController = UITabBarController()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Home View Controller setup
        let homeVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)  // House icon for Home

        // Settings View Controller setup
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let settingsNavController = UINavigationController(rootViewController: settingsVC)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 1)  // Gear icon for Settings

        // Profile View Controller setup
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let profileNavController = UINavigationController(rootViewController: profileVC)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle.fill"), tag: 2)  // Person icon for Profile

        
        
        tabBarController.viewControllers = [homeNavController,profileNavController ,settingsNavController]
        
        
        if let window = view.window {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

