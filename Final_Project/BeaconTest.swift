//
//  BeaconTest.swift
//  Final_Project
//
//  Created by Narathorn Dontricharoen on 6/5/2562 BE.
//  Copyright © 2562 Narathorn Dontricharoen. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class BeaconTest: UIViewController, CBPeripheralManagerDelegate {
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocalBeacon()
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
//    var myBeacon: CLBeaconRegion!
//    var beaconData: NSDictionary!
//    var peripheralMgr: CBPeripheralManager!
//
//    let myRegionID = "myRegionID"
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    @IBAction func startPressed(_ sender: Any) {
//        guard myBeacon == nil else { return }
//
//        let beaconUUID = "7FA08BC7-A55F-45FC-85C0-0BF26F899530"
//        let beaconMajor: CLBeaconMajorValue = 123
//        let beaconMinor: CLBeaconMinorValue = 456
//
//        let uuid = UUID(uuidString: beaconUUID)!
//        myBeacon = CLBeaconRegion(proximityUUID: uuid, major: beaconMajor, minor: beaconMinor, identifier: "MyIdentifier")
//
//        beaconData = myBeacon.peripheralData(withMeasuredPower: -59)
//        peripheralMgr = CBPeripheralManager(delegate: self, queue: nil, options: nil)
//    }
//
//    @IBAction func stopPressed(_ sender: Any) {
//        guard peripheralMgr != nil else { return }
//
//        peripheralMgr.stopAdvertising()
//        peripheralMgr = nil
//        beaconData = nil
//        myBeacon = nil
//    }
//
//    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        if peripheral.state == .poweredOn {
//            peripheralMgr.startAdvertising(beaconData as! [String: AnyObject]!)
//            print("ONNNN")
//        } else if peripheral.state == .poweredOff {
//            peripheralMgr.stopAdvertising()
//            print("OFFFF")
//        }
//    }
    
}
