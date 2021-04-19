/*
    HIDController class is the entry point into the HIDEngine library. Users must create an instance of HIDController
    class with the device IDs. The controller instance will internally take care of finding, opening, and later closing the device.
    users can also subclass HIDController class to add features specefic to the device you are programming for.
    
    only a HIDController object can initialize a HIDDevice. this way the controller can initialize the library and open the device, 
    and later close the device and release the library in the correct order. for the same reason only a HIDController object can open 
    and close a hid device. therefore it is the responsibility of the controller to execute the following operations in the correct order
    for good memory management:
        ** find the device by device ids
        ** if the device is found:
            * initialize hidapi library
            * open the found device with device path or device ids
        ** at exit:
            * if there is a device open
                * close the open device
                * release hidapi library

    users of the library will have read-only access to the active device's properties in the controller. at the time being a controller 
    represents 1 device. this will be expanded with proper active device management system to allow for adding extra devices and switching 
    between then at run time.
    
    todo:: add an algorithm for adding new devices, changing active device, and managing devices' states.

    the controller also offers interface layer into the device send and receive functions. the controller takes care of parsing
    incoming data, and formatting outgoing data through auxiliary HIDParser and HIDFormatter objects that are specific to the
    hid device in question. when a parser and/or a formatter are not available, the controllers send the data provided by the user
    as is and therefor it is the responsibility of the library user to provid correctly structured data and similarly interpret the
    incoming raw hid data which is an array of hex values.
*/

import Chidapi


open class HIDController {
    
    private var activeDevice: HIDDevice?
    private var parser: HIDParser?
    private var formatter: HIDFormatter?

    public init?(vendorID: UInt16, productID: UInt16) {
        guard isValidDeviceID(vendorID: vendorID, productID: productID) else { return nil }
        initializeLibrary()
        let device = HIDDevice(vendorID: vendorID, productID: productID)
        self.activeDevice = device
    }

    deinit {
        if activeDevice != nil {
            activeDevice = nil
            releaseLibrary()
        }
        parser = nil
        formatter = nil
    }   

    private func isValidDeviceID(vendorID: UInt16, productID: UInt16) -> Bool {
        let deviceList = hid_enumerate(vendorID, productID)
        defer { hid_free_enumeration(deviceList) }
        if deviceList?.pointee != nil {
            return true
        } else {
            return false
        }
    }

    private func initializeLibrary() {
        let result = hid_init()
        guard result == 0 else { fatalError("failed to initialize hidapi library") }
    }

    private func releaseLibrary() {
        let result = hid_exit()
        guard result == 0 else { fatalError("failed to exit hidapi library") }
    }

    public func send(data: Array<UInt8>) {
        if activeDevice != nil {
            if formatter != nil {
                if let formatted = formatter?.formatted(data: data) {
                    activeDevice!.send(data: Array(formatted))
                }
            } else {
                activeDevice!.send(data: data)
            }
        }
    }

    public func receive() -> Array<UInt8> {
        guard activeDevice != nil else { return [] }
        let data = activeDevice!.receive()
        if parser != nil {
            let parsed = parser!.parsed(data: data)
            return Array(parsed)
        }
        return data
    }

    public func setParser(_ parser: HIDParser) {
        self.parser = parser
    }

    public func setFormatter(_ formatter: HIDFormatter) {
        self.formatter = formatter
    }

    public func setBlockingMode(to mode: BlockingMode) {
        self.activeDevice?.setBlockingMode(to: mode)
    }
}

extension HIDController {
    public var path: String? { return activeDevice?.path }
	public var vendorID: UInt16? { return activeDevice?.vendorID }
	public var productID: UInt16? { return activeDevice?.productID }
	public var serialNumber: String? { return activeDevice?.serialNumber }
	public var releaseNumber: UInt16? { return activeDevice?.releaseNumber }
	public var manufacturerString: String? { return activeDevice?.manufacturerString }
	public var productString: String? { return activeDevice?.productString }
	public var usagePage: UInt16? { return activeDevice?.usagePage }
	public var usage: UInt16? { return activeDevice?.usage }
	public var interfaceNumber: Int32? { return activeDevice?.interfaceNumber }
}