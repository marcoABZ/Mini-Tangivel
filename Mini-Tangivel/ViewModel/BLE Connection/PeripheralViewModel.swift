//
//  CalculatorViewModel.swift
//  BLECalculator
//
//  Created by Marco Zulian on 16/05/22.
//

import Foundation
import CoreBluetooth
import SwiftUI

class PeripheralViewModel: NSObject, ObservableObject, Identifiable {
    var id = UUID()
    
    @Published var output = "Disconnected"
    @Published var connected = false
    var delegate: PeripheralViewModelDelegate?
    
    func send(_ row: Int, color: UIColor) {
        guard let peripheral = connectedPeripheral,
              let inputChar = inputChar else {
                  output = "Connection error"
                  return
              }
        
        let components = color.rgba
        let message = [UInt8(row), UInt8(components.0 * 255), UInt8(components.1 * 255), UInt8(components.2 * 255)]
        
        peripheral.writeValue(Data(message), for: inputChar, type: .withoutResponse)
    }
    
    private var centralQueue: DispatchQueue?
    
    private let serviceUUID = CBUUID(string: "05565138-AB96-420D-AB0B-786B55BEC462")
    
    private let inputCharUUID = CBUUID(string: "6B1269A5-FD1C-4DFC-93E7-DEEC5922C0BF")
    private var inputChar: CBCharacteristic?
    private let outputCharUUID = CBUUID(string: "BAF2B06D-D2CF-4655-85FF-1C85262ED2AA")
    private var outputChar: CBCharacteristic?
    
    private var centralManager: CBCentralManager?
    private var connectedPeripheral: CBPeripheral?
    
    func connectCalculator() {
        output = "Connecting..."
        centralQueue = DispatchQueue(label: "test.discovery")
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    func disconnectCalculator() {
        guard let manager = centralManager,
              let peripheral = connectedPeripheral else { return }
        
        manager.cancelPeripheralConnection(peripheral)
    }
}

extension PeripheralViewModel: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central Manager state changed: \(central.state)")
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: [serviceUUID], options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "UNKNOWN")")
        central.stopScan()
        
        connectedPeripheral = peripheral
        central.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "UNKNOWN")")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "UNKNOWN")")
        
        centralManager = nil
        
        DispatchQueue.main.async {
            self.connected = false
            self.output = "Disconnected"
        }
    }
}

extension PeripheralViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovered services for \(peripheral.name ?? "UNKNOWN")")
        
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Discovered characteristics for \(peripheral.name ?? "UNKNOWN")")
        
        guard let characteristics = service.characteristics else { return }
        
        for ch in characteristics {
            switch ch.uuid {
            case inputCharUUID:
                inputChar = ch
            case outputCharUUID:
                outputChar = ch
                peripheral.setNotifyValue(true, for: ch)
            default:
                break
            }
        }
        
        DispatchQueue.main.async {
            self.connected = true
            self.output = "Connected."
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("Notification state changed to \(characteristic.isNotifying)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Characteristic updated: \(characteristic.uuid)")
        if characteristic.uuid == outputCharUUID, let data = characteristic.value {
            let bytes:[UInt8] = data.map {$0}
            
            print(bytes)
            
            if let answer = bytes.first {
                if let delegate = delegate {
                    DispatchQueue.main.async {
                        delegate.handleClick(at: Int(answer))
                    }
                }
            }
        }
    }
}

protocol PeripheralViewModelDelegate {
    func handleClick(at row: Int)
}
