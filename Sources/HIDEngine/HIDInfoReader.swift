import Chidapi

internal struct HIDInfoReader {


    private let _path: String
	private let _vendorID: UInt16
	private let _productID: UInt16
	private let _serialNumber: String
	private let _releaseNumber: UInt16
	private let _manufacturerString: String
	private let _productString: String
	private let _usagePage: UInt16
	private let _usage: UInt16
	private let _interfaceNumber: Int32

    internal init?(vendorID: UInt16, productID: UInt16) {
        guard let devices = hid_enumerate(vendorID, productID) else { return nil }
        defer { hid_free_enumeration(devices) }
        let deviceInfo = devices.pointee
        self.init(deviceInfo: deviceInfo)
    }

    internal init(deviceInfo: hid_device_info) {
        self._path = String(cString: deviceInfo.path)
        self._vendorID = deviceInfo.vendor_id
        self._productID = deviceInfo.product_id
        self._serialNumber = String(wcString: deviceInfo.serial_number) ?? "serial number N/A"
        self._releaseNumber = deviceInfo.release_number
        self._manufacturerString = String(wcString: deviceInfo.manufacturer_string) ?? "manufacturer name N/A"
        self._productString = String(wcString: deviceInfo.product_string) ?? "product name N/A"
        self._usagePage = deviceInfo.usage_page
        self._usage = deviceInfo.usage
        self._interfaceNumber = deviceInfo.interface_number
    }

    internal var path: String { return self._path }
	internal var vendorID: UInt16 { return self._vendorID }
	internal var productID: UInt16 { return self._productID }
	internal var serialNumber: String { return self._serialNumber }
	internal var releaseNumber: UInt16 { return self._releaseNumber }
	internal var manufacturerString: String { return self._manufacturerString }
	internal var productString: String { return self._productString }
	internal var usagePage: UInt16 { return self._usagePage }
	internal var usage: UInt16 { return self._usage }
	internal var interfaceNumber: Int32 { return self._interfaceNumber }
}