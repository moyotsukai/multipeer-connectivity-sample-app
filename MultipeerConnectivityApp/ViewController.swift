//
//  ViewController.swift
//  MultipeerConnectivityApp
//
//  Created by Owner on 2024/07/10.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    private var multipeerConnectivityService: MultipeerConnectivityService = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multipeerConnectivityService.serviceDelegate = self
        
        multipeerConnectivityService.startHosting()
        multipeerConnectivityService.joinSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        multipeerConnectivityService.endActivity()
    }
    
    @IBAction func sendData() {
        let text = "Hello world!"
        
        if let data = text.data(using: .utf8) {
            multipeerConnectivityService.send(data: data)
        }
    }
    
}

extension ViewController: MCServiceDelegate {
    
    func didReceiveData(data: Data) {
        let dataString = String(data: data, encoding: .utf8) ?? ""
        DispatchQueue.main.async {
            self.label.text = dataString
        }
        print(dataString)
    }
    
    func didReceiveInvitation(peerID: MCPeerID, session: MCSession, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let alert = UIAlertController(title: "接続確認", message: "\(peerID.displayName) と接続しますか？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "許可", style: .default, handler: { _ in
            invitationHandler(true, session)
        }))
        alert.addAction(UIAlertAction(title: "拒否", style: .cancel, handler: { _ in
            invitationHandler(false, nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
