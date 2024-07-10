//
//  ViewController.swift
//  MultipeerConnectivityApp
//
//  Created by Owner on 2024/07/10.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    private var multipeerConnectivityService: MultipeerConnectivityService = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multipeerConnectivityService.didReceiveMessage = { data in
            let dataString = String(data: data, encoding: .utf8) ?? ""
            DispatchQueue.main.async {
                self.label.text = dataString
            }
            print(dataString)
        }
        
        multipeerConnectivityService.startHosting()
        multipeerConnectivityService.joinSession()
    }
    
    @IBAction func sendData() {
        let text = "Hello world!"
        
        if let data = text.data(using: .utf8) {
            multipeerConnectivityService.send(data: data)
        }
    }
    
}

