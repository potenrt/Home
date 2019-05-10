//
//  QRScannerController.swift
//  Final_Project
//
//  Created by Narathorn Dontricharoen on 1/5/2562 BE.
//  Copyright © 2562 Narathorn Dontricharoen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Foundation
import AVFoundation

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var roomTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var bgLabel: UILabel!
    
    var refAddDeviecs: DatabaseReference!
    let user = Auth.auth().currentUser
    
    var idNode:String = ""
    var room:String = ""
    var type:String = ""
    var uid:String = ""
    
    var video = AVCaptureVideoPreviewLayer()
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        room = roomTextField.text!
        refAddDeviecs = Database.database().reference()
        refAddDeviecs.child(uid).child(idNode).setValue(["room": room, "status": "0", "type": type])
        
        let alertController = UIAlertController(title: "Completed!!", message: "Add Completed", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("You've pressed default");
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let user = user {
            uid = user.uid
        }
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.orange
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        addButton.isEnabled = false
        
//        roomTextField.layer.cornerRadius = 5
//        roomTextField.layer.borderWidth = 1
//        roomTextField.layer.borderColor = UIColor.orange.cgColor
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.setTitleColor(UIColor.black, for: .normal)
        
        let session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            print("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubviewToFront(bgLabel)
        self.view.bringSubviewToFront(addButton)
        self.view.bringSubviewToFront(roomTextField)
        session.startRunning()
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    var message = "\(object.stringValue)"
                    var firstHalf = message.dropFirst(10)
                    let finalString = firstHalf.dropLast(2)
                    print("DATA = " + finalString)
                    var dataArr = finalString.split(separator: ",")
                    
                    print(dataArr[0])
                    print(dataArr[1])
                    print(dataArr[2])
                    
                    var key:String = String(dataArr[0])
                    idNode = String(dataArr[1])
                    type = String(dataArr[2])
                    
                    if key == "has" {
                        addButton.isEnabled = true
                        addButton.setTitle("ADD", for: .normal)
                        addButton.layer.cornerRadius = 5
                        addButton.layer.borderWidth = 1
                        addButton.layer.borderColor = UIColor.orange.cgColor
                        addButton.setTitleColor(UIColor.orange, for: .normal)
                    } else {
                        addButton.isEnabled = false
                        addButton.setTitle("Please Scan QRCode!!", for: .normal)
                        addButton.layer.cornerRadius = 5
                        addButton.layer.borderWidth = 1
                        addButton.layer.borderColor = UIColor.black.cgColor
                        addButton.setTitleColor(UIColor.black, for: .normal)
                    }
                    
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        roomTextField.resignFirstResponder()
    }
}
