//
//  HomeScreenController.swift
//  Final_Project
//
//  Created by Narathorn Dontricharoen on 21/3/2562 BE.
//  Copyright © 2562 Narathorn Dontricharoen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreLocation
import CoreBluetooth

class HomeScreenController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var deviceID = [String]()
    var roomArr = [String]()
    var typeArr = [String]()
    var statusArr = [String]()
    var refDeviecs: DatabaseReference!
    let user = Auth.auth().currentUser
    var uid = ""
    
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocalBeacon()
        
        if let user = user {
            uid = user.uid
        }
        
        print("User ID: " + uid)
        refDeviecs = Database.database().reference().child(uid)
        refDeviecs.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                self.roomArr.removeAll()
                self.typeArr.removeAll()
                self.statusArr.removeAll()
                for devices in snapshot.children.allObjects as! [DataSnapshot] {
                    let deviceObject = devices.value as! [String: AnyObject]
                    let deviceKey = devices.key
                    let room = deviceObject["room"]
                    let type = deviceObject["type"]
                    let status = deviceObject["status"]
                    self.deviceID.append(deviceKey)
                    self.roomArr.append(room as! String)
                    self.typeArr.append(type as! String)
                    self.statusArr.append(status as! String)
                }
                self.collectionView.reloadData()
            }
        })
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "homekit_wallpaper.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.roomLabel.text = roomArr[indexPath.item]
        cell.typeLabel.text = typeArr[indexPath.item]
        
        for i in 0...(statusArr.count-1) {
            print("Index " + String(i) + " value : " + statusArr[i])
        }
        
        if typeArr[indexPath.item] == "Light" {
            if statusArr[indexPath.item] == "0" {
                cell.iconImageView.image = UIImage(named: "light_off")
                cell.statusLabel.text = "Off"
                cell.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 0.91)
            } else if statusArr[indexPath.item] == "1" {
                cell.iconImageView.image = UIImage(named: "light_on")
                cell.statusLabel.text = "On"
                cell.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
            }
        } else if typeArr[indexPath.item] == "Door" {
            if statusArr[indexPath.item] == "0" {
                cell.iconImageView.image = UIImage(named: "lock")
                cell.statusLabel.text = "Locked"
                cell.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 0.91)
            } else if statusArr[indexPath.item] == "1" {
                cell.iconImageView.image = UIImage(named: "unlock")
                cell.statusLabel.text = "Unlocked"
                cell.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
            }
        } else if typeArr[indexPath.item] == "Fan" {
            if statusArr[indexPath.item] == "0" {
                cell.iconImageView.image = UIImage(named: "fan_off")
                cell.statusLabel.text = "Off"
                cell.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 0.91)
            } else if statusArr[indexPath.item] == "1" {
                cell.iconImageView.image = UIImage(named: "fan_on")
                cell.statusLabel.text = "On"
                cell.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
            }
        }

        cell.contentMode = UIView.ContentMode.scaleAspectFill
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 20

        //self.collectionView.reloadItems(at: [indexPath])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = deviceID[indexPath.item]
        var refStatus: DatabaseReference
        var status = ""
        refStatus = Database.database().reference().child(uid).child(key)
        refStatus.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as! NSDictionary
            status = value["status"] as! String
            print("Statussss: " + status)
            if status == "1" {
                refStatus.updateChildValues(["status": "0"])
            } else if status == "0" {
                refStatus.updateChildValues(["status": "1"])
            }
        })
    }
    
    func initLocalBeacon() {
        if localBeacon != nil {
            stopLocalBeacon()
        }
        
        let localBeaconUUID = "7FA08BC7-A55F-45FC-85C0-0BF26F899530"
        let localBeaconMajor: CLBeaconMajorValue = 123
        let localBeaconMinor: CLBeaconMinorValue = 456
        
        let uuid = UUID(uuidString: localBeaconUUID)!
        localBeacon = CLBeaconRegion(proximityUUID: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: "Your private identifer here")
        
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
        } else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
        }
    }
    
}


