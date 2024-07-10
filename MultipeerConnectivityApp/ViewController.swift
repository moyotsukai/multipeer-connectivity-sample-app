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
        
        multipeerConnectivityService.didReceiveData = { data in
            let dataString = String(data: data, encoding: .utf8) ?? ""
            DispatchQueue.main.async {
                self.label.text = dataString
            }
            print(dataString)
        }
        
        multipeerConnectivityService.didReceiveInvitation = { peerID, session, invitationHandler in
            let alert = UIAlertController(title: "接続確認", message: "\(peerID.displayName) と接続しますか？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "許可", style: .default, handler: { _ in
                invitationHandler(true, session)
            }))
            alert.addAction(UIAlertAction(title: "拒否", style: .cancel, handler: { _ in
                invitationHandler(false, nil)
            }))
            self.present(alert, animated: true, completion: nil)
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

