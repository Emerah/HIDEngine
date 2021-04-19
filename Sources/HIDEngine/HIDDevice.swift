import Chidapi

internal class HIDDevice {

    private var handle: OpaquePointer?
    private var infoReader: HIDInfoReader?
    private var _blockingMode: BlockingMode

    internal init?(vendorID: UInt16, productID: UInt16) {
        self._blockingMode = .blocking
        let deviceList = hid_enumerate(vendorID, productID)
        defer { hid_free_enumeration(deviceList) }
        if deviceList?.pointee != nil {
            let deviceInfo = deviceList!.pointee
            if let handle = hid_open_path(deviceInfo.path) {
                self.handle = handle
                self.infoReader = HIDInfoReader(deviceInfo: deviceInfo)
            }
        } else {
            return nil
        }
    }

    deinit {
        if handle != nil {
            close()
        }
        handle = nil
        infoReader = nil
    }

    private func close() {
        hid_close(handle)
    }
    
    internal func send(data: Array<UInt8>) {
        var dataToSend: Array<UInt8> = data
        let numBytes = hid_write(handle, &dataToSend, 65)
        guard numBytes != -1 else { fatalError("error sending data to hid device") }
        // print("sent \(numBytes) bytes")
    }

    internal func receive(waitTime: Int32 = 0) -> Array<UInt8> {
        var data: Array<UInt8> = .init(repeating: 0, count: 65)
        var numBytes: Int32
        if waitTime <= 0 {
            numBytes = hid_read(handle, &data, 65)
        } else {
            numBytes = hid_read_timeout(handle, &data, 65, waitTime)
        }
        guard numBytes != -1 else { fatalError("failed to receive data from device") }
        // print("received \(numBytes) bytes")
        return data
    }

    internal func setBlockingMode(to mode: BlockingMode) {
        self._blockingMode = mode
        let errCode = hid_set_nonblocking(handle, mode.rawValue)
        guard errCode == 0 else { fatalError("failed to set blocking mode") }
    }
}

extension HIDDevice {

    internal var path: String? { return infoReader?.path }
	internal var vendorID: UInt16? { return infoReader?.vendorID }
	internal var productID: UInt16? { return infoReader?.productID }
	internal var serialNumber: String? { return infoReader?.serialNumber }
	internal var releaseNumber: UInt16? { return infoReader?.releaseNumber }
	internal var manufacturerString: String? { return infoReader?.manufacturerString }
	internal var productString: String? { return infoReader?.productString }
	internal var usagePage: UInt16? { return infoReader?.usagePage }
	internal var usage: UInt16? { return infoReader?.usage }
	internal var interfaceNumber: Int32? { return infoReader?.interfaceNumber }
}