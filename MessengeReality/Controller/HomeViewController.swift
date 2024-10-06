//
//  HomeViewController.swift
//  MessengeReality
//
//  Created by АА on 02.10.24.
//

import UIKit

class HomeViewController: UIViewController,UIApplicationDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = UserDefaults.standard.string(forKey: "username")
        UserDefaults.standard.set(String(describing: type(of: self)), forKey: "lastOpenViewController")
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.set(String(describing: type(of: self)), forKey: "lastOpenViewController")
        print(UserDefaults.standard.string(forKey: "lastOpenViewController") ?? "No last open view controller")
    }

    
}
