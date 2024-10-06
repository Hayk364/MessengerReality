//
//  LoginViewController.swift
//  MessengeReality
//
//  Created by АА on 02.10.24.
//

import UIKit

class LoginViewController: UIViewController {
    var textFieldName = UITextField()
    var textFieldPassword = UITextField()
    
    var loginButton = UIButton()
    var hidePasswordButton = UIButton()
    
    var mainLabel = UILabel()
    
    var alertForError: UIAlertController?
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 0.5)
        UserDefaults.standard.set(String(describing: type(of: self)), forKey: "lastOpenViewController")
        
        
        DispatchQueue.main.async {
            self.createTextFields()
            self.createLoginButton()
            self.createHidePasswordButton()
            self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: true)
        }
        
    }
    @objc final func updateUI(){
        loginButtonIsEnabled()
    }
    final func createHidePasswordButton(){
        self.hidePasswordButton.setTitle("𓁹", for: .normal)
        self.hidePasswordButton.backgroundColor = .none;  self.view.addSubview(self.hidePasswordButton)
        self.hidePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.hidePasswordButton.addTarget(self, action: #selector(hidePassword), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.hidePasswordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 80),
            self.hidePasswordButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 335),
            self.hidePasswordButton.widthAnchor.constraint(equalToConstant: 40),
            self.hidePasswordButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    @objc final func hidePassword(){
        self.view.endEditing(true)
        if self.textFieldPassword.isSecureTextEntry{
            self.textFieldPassword.isSecureTextEntry = !self.textFieldPassword.isSecureTextEntry
            self.hidePasswordButton.setTitleColor(.blue, for: .normal)
        }
        else{
            self.textFieldPassword.isSecureTextEntry = !self.textFieldPassword.isSecureTextEntry
            self.hidePasswordButton.setTitleColor(.white, for: .normal)
        }
    }
    final func createLoginButton() {
        self.loginButton.setTitle("Login", for: .normal)
        self.loginButton.isEnabled = true
        self.loginButton.backgroundColor = UIColor(red: 0.6, green: 0.7, blue: 0.7, alpha: 0.9)
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.layer.cornerRadius = 20
        self.loginButton.addTarget(self, action: #selector(Login), for: .touchUpInside)
        loginButtonIsEnabled()
        self.view.addSubview(self.loginButton)
        
        NSLayoutConstraint.activate([
            self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loginButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 430),
            self.loginButton.widthAnchor.constraint(equalToConstant: 200),
            self.loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func Login(){
        print("Login")
        let user = User(id: nil, name: self.textFieldName.text, password: self.textFieldPassword.text)
        Model.shared.findUser(newUser: user) { result, isFind in
            DispatchQueue.main.async {
                if isFind{
                    UserDefaults.standard.set(self.textFieldName.text, forKey: "username")
                    self.navigationController?.viewControllers = [HomeViewController()]
                    print("Name \(UserDefaults.standard.string(forKey: "username"))")
                }
                else{
                    self.createErrorAlert(error: "User Is Not Found")
                }
            }
        }
    }
    final func createErrorAlert(error:String){
        self.alertForError = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.alertForError = nil
        }
        self.alertForError?.addAction(action)
        self.present(self.alertForError!, animated: true, completion: nil)
    }
    final func loginButtonIsEnabled(){
        DispatchQueue.main.async {
            let isNameNotEmpty = !(self.textFieldName.text?.isEmpty ?? true)
            let isPasswordNotEmpty = !(self.textFieldPassword.text?.isEmpty ?? true)
            if isNameNotEmpty && isPasswordNotEmpty {
                self.loginButton.isEnabled = true
                self.loginButton.backgroundColor = .blue
            } else {
                self.loginButton.isEnabled = false
                self.loginButton.backgroundColor = UIColor(red: 0.6, green: 0.7, blue: 0.7, alpha: 0.9)
            }
        }
    }
    final func createTextFields() {
        //Create TextField For UserName
        self.textFieldName.placeholder = "Name"
        self.textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldName.layer.cornerRadius = 20
        self.textFieldName.backgroundColor = UIColor(red: 0.6, green: 0.7, blue: 0.7, alpha: 0.9)
        self.textFieldName.textAlignment = .center
        self.view.addSubview(self.textFieldName)
        
        NSLayoutConstraint.activate([
            self.textFieldName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldName.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 250),
            self.textFieldName.widthAnchor.constraint(equalToConstant: 200),
            self.textFieldName.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        //Create TextField ForPassword
        self.textFieldPassword.placeholder = "Password"
        self.textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldPassword.layer.cornerRadius = 20
        self.textFieldPassword.backgroundColor = UIColor(red: 0.6, green: 0.7, blue: 0.7, alpha: 0.9)
        self.textFieldPassword.textAlignment = .center
        self.textFieldPassword.isSecureTextEntry = true
        self.view.addSubview(self.textFieldPassword)
        
        NSLayoutConstraint.activate([
            self.textFieldPassword.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldPassword.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 330),
            self.textFieldPassword.widthAnchor.constraint(equalToConstant: 200),
            self.textFieldPassword.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
