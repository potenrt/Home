//
//  QRCodeGeneratorController.swift
//  Final_Project
//
//  Created by Narathorn Dontricharoen on 4/5/2562 BE.
//  Copyright © 2562 Narathorn Dontricharoen. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class QRCodeGeneratorController: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var generateButton: UIButton!
    
    var beaconRegion : CLBeaconRegion! = nil
    var beaconPeripheralData : NSDictionary = NSDictionary()
    var peripheralManager : CBPeripheralManager = CBPeripheralManager()
    
    @IBAction func generateButtonPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            let stringBuilder = "{\"type\":\"login\",\"user\":\"" + email + "\",\"password\":\"" + password + "\"}"
            let data = stringBuilder.data(using: String.Encoding.ascii)
            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(data, forKey: "inputMessage")
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                if let output = filter.outputImage?.transformed(by: transform) {
                    qrCodeImage.image = UIImage(ciImage: output)
                    qrCodeImage.contentMode = UIView.ContentMode.scaleAspectFill
                }
            }
        }
//        beaconPeripheralData = beaconRegion .peripheralData(withMeasuredPower: nil)
//        peripheralManager = CBPeripheralManager.init(delegate: self, queue: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initBeaconRegion()
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.orange
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "homekit_wallpaper.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        generateButton.backgroundColor = UIColor.white
        generateButton.layer.cornerRadius = 5
        generateButton.layer.borderWidth = 1
        generateButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state == .poweredOn) {
            peripheralManager .startAdvertising(beaconPeripheralData as? [String : Any])
            print("Powered On")
        } else {
            peripheralManager .stopAdvertising()
            print("Not Powered On, or some other error")
        }
    }
    
    func initBeaconRegion() {
        beaconRegion = CLBeaconRegion.init(proximityUUID: UUID.init(uuidString: "E06F95E4-FCFC-42C6-B4F8-F6BAE87EA1A0")!,
                                           major: 1233,
                                           minor: 45,
                                           identifier: "Narathorn")
    }
}
