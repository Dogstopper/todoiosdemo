//
//  LoginViewController.swift
//  passdown-iOS
//
//  Created by Stephen Schwahn on 1/4/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Variables
    
    var isFirstOpen: Bool!
    
    // MARK: - Textfield Borders
    
    var emailBorder: UIView!
    var passwordBorder: UIView!
    
    // MARK: - Services and Modele
    
    var user : User?

    // MARK: - Setup Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style text fields
        
        let white = UIColor.white
        
        emailTextField.layer.backgroundColor = UIColor.white.withAlphaComponent(0.1).cgColor
        emailTextField.layer.cornerRadius = 2.0
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName: white])
        let emailImageView = UIImageView(image: UIImage(named: "email_icon.png"))
        emailImageView.frame = CGRect(x: 0, y: 0, width: 46, height: 16)
        emailImageView.contentMode = UIViewContentMode.scaleAspectFit
        emailTextField.leftViewMode = UITextFieldViewMode.always
        emailTextField.leftView = emailImageView
        
        passwordTextField.layer.backgroundColor = UIColor.white.withAlphaComponent(0.1).cgColor
        passwordTextField.layer.cornerRadius = 2.0
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: white])
        let passwordImageView = UIImageView(image: UIImage(named: "password_icon.png"))
        passwordImageView.frame = CGRect(x: 0, y: 0, width: 46, height: 21)
        passwordImageView.contentMode = UIViewContentMode.scaleAspectFit
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        passwordTextField.leftView = passwordImageView
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Configure warning label
        
        warningLabel.alpha = 0.0
        
        // Register for Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Style buttons
        
        let buttonBackground = UIView(frame: self.loginButton.frame)
        buttonBackground.layer.backgroundColor = UIColor(red: 10/255.0, green: 211/255.0, blue: 138/255.0, alpha: 1.0).cgColor
        
        UIGraphicsBeginImageContext(buttonBackground.bounds.size)
        buttonBackground.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        loginButton.setBackgroundImage(backgroundImage, for: UIControlState())
        loginButton.layer.cornerRadius = 2.0
        loginButton.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Style text field borders
        
        emailBorder = UIView(frame: self.emailTextField.frame)
        emailBorder.layer.cornerRadius = 2.0
        emailBorder.layer.borderColor = warningLabel.textColor.cgColor
        emailBorder.layer.borderWidth = 2.0
        emailBorder.alpha = 0.0
        
        passwordBorder = UIView(frame: self.passwordTextField.frame)
        passwordBorder.layer.cornerRadius = 2.0
        passwordBorder.layer.borderColor = warningLabel.textColor.cgColor
        passwordBorder.layer.borderWidth = 2.0
        passwordBorder.alpha = 0.0
        
        
        self.view.addSubview(emailBorder)
        self.view.addSubview(passwordBorder)
    }
    
    // textfield hide func for return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTage = textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
            login(textField)
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    func tapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: - Keyboard show/hide
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize.height), right: 0.0)
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize.height), right: 0.0)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }


    // MARK: - Status Bar Style
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    // MARK: - Buttons Handlers
    
    @IBAction func login(_ sender: AnyObject) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            self.highlightMissingFields()
            return
        }
        
        // Validate that the text fields are valid
        if EmailPasswordHelpers.isValidEmail(self.emailTextField.text!) && EmailPasswordHelpers.isValidPassword(passwordTextField.text!) {
            loginUser()
        } else {
            Helpers.displayAlertWithTitle("😳OOPS😳\nThere seems to be a problem with your email or password. Please check for typos and try again.", viewController: self)
        }
    }
    
    private func loginUser() {
        let email = self.emailTextField.text!.lowercased()
        let password = self.passwordTextField.text!
        Helpers.loginUser(email: email, password: password, with: getUser, failure: displayError)
    }
    
    private func getUser(email: String, accessToken: String) {
        Helpers.getUser(accessToken: accessToken,
            with: {
                self.performSegue(withIdentifier: "loginToTodo", sender: self)
            },
            failure: displayError)
    }
    
    private func displayError(error: String) {
        Helpers.displayAlertWithTitle(error, viewController: self)
    }
    
    @IBAction func backToRegister(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Highlight Text Fields When No Data is Entered
    
    func highlightMissingFields() {
        warningLabel.alpha = 1.0
        
        if emailTextField.text == "" {
            self.emailBorder.alpha = 1.0
            UIView.animate(withDuration: 1.0, delay: 0.3, options: [], animations: {
                self.emailBorder.alpha = 0.0
                }, completion: nil)
        }
        
        if passwordTextField.text == "" {
            self.passwordBorder.alpha = 1.0
            UIView.animate(withDuration: 1.0, delay: 0.3, options: [], animations: {
                self.passwordBorder.alpha = 0.0
                }, completion: nil)
        }
    }
    
    // MARK: - iOS lifecycle Handler
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static func showPopupMessage(_ view: UIViewController, title: String!, message: String) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        view.present(alertController, animated: true, completion: nil)
    }
}

