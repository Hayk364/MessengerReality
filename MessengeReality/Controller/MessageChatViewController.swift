//
//  MessageChatViewController.swift
//  MessengeReality
//
//  Created by АА on 12.10.24.
//

import UIKit

class MessageChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = UserDefaults.standard.string(forKey: "sendusername")
    }

}
