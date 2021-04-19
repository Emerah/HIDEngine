import Chidapi


public func displayAllAttachedHidDevices() {
    displayHidDevice(vendorID: 0x00, productID: 0x00)
}

internal func displayHidDevice(vendorID: UInt16, productID: UInt16) {
    if vendorID == 0 && productID == 0 {
        let devices = hid_enumerate(vendorID, productID)
        var devicePointer = devices
        defer { hid_free_enumeration(devices) }
        while devicePointer != nil {
            if let device = devicePointer?.pointee {
                print("Device manufacturer: \(String(wcString: device.manufacturer_string) ?? "NONE")")
                print("Device name: \(String(wcString: device.product_string) ?? "NONE")")
                print("Device serial number: \(String(wcString: device.serial_number) ?? "NONE")")
                print("Device manufacturer id: \(device.vendor_id)")
                print("Device id: \(device.product_id)")
                print("Device path: \(String(cString: device.path))")
                print("Device usage page: \(device.usage_page)")
                print("Device usage: \(device.usage)")
                print("Device interface number: \(device.interface_number)")
                print("**--**--**--**--**--**--**--**--**--**--**--**--**--**\n")
                devicePointer = device.next
            }
        }
    }
}