//
//  ViewController.swift
//  MessengeReality
//
//  Created by АА on 01.10.24.
//

import UIKit

class ViewController: UIViewController,UIApplicationDelegate {
    var textFieldName = UITextField()
    var textFieldPassword = UITextField()
    
    var registerButton = UIButton()
    var hidePasswordButton = UIButton()
    var goToRegisterButton = UIButton()
    
    var mainLabel = UILabel()
    
    
    var alertForError: UIAlertController?
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 0.5)
        UserDefaults.standard.set(String(describing: type(of: self)), forKey: "lastOpenViewController")
        
        
        createTextFields()
        createRegisterButton()
        createHidePasswordButton()
        goToLogin()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: true)
        }
    }
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.set(String(describing: type(of: self)), forKey: "lastOpenViewController")
        print(UserDefaults.standard.string(forKey: "lastOpenViewController")!)
    }
    @objc final func updateUI(){
        registerButtonIsEnabled()
    }
    final func goToLogin(){
        self.goToRegisterButton.setTitle("Login", for: .normal)
        self.goToRegisterButton.addTarget(self, action: #selector(GoToLoginPage), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.goToRegisterButton)
    }
    @objc final func GoToLoginPage(){
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
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
    final func createRegisterButton() {
        self.registerButton.setTitle("Register", for: .normal)
        self.registerButton.isEnabled = true
        self.registerButton.backgroundColor = UIColor(red: 0.6, green: 0.7, blue: 0.7, alpha: 0.9)
        self.registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.registerButton.layer.cornerRadius = 20
        self.registerButton.addTarget(self, action: #selector(Register), for: .touchUpInside)
        registerButtonIsEnabled()
        self.view.addSubview(self.registerButton)
        
        NSLayoutConstraint.activate([
            self.registerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.registerButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 430),
            self.registerButton.widthAnchor.constraint(equalToConstant: 200),
            self.registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func Register(){
            print("Register")
            guard let name = self.textFieldName.text, !name.isEmpty,
                      let password = self.textFieldPassword.text, !password.isEmpty else {
                    print("Name or password is empty")
                    return
                }
            let user = User(id: nil, name: name, password: password)
            Model.shared.createUser(user: user) { result in            DispatchQueue.main.async {
                     switch result{
                     case .success(_):
                         UserDefaults.standard.set(self.textFieldName.text, forKey: "username")
                         print("Name \(String(describing: UserDefaults.standard.string(forKey:"username")))")
                         self.navigationController?.viewControllers = [HomeViewController()]
                         break;
                     case .failure(let error):
                         self.createErrorAlert(error: error.localizedDescription)
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
    final func registerButtonIsEnabled(){
        DispatchQueue.main.async {
            let isNameNotEmpty = !(self.textFieldName.text?.isEmpty ?? true)
            let isPasswordNotEmpty = !(self.textFieldPassword.text?.isEmpty ?? true)
            if isNameNotEmpty && isPasswordNotEmpty {
                self.registerButton.isEnabled = true
                self.registerButton.backgroundColor = .blue
            } else {
                self.registerButton.isEnabled = false
                self.registerButton.backgroundColor = UIColor(red: 0.6, green: 0.7, blue: 0.7, alpha: 0.9)
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
