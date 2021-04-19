
public enum BlockingMode: Int32 { 
    case blocking, noneBlocking 
}

public struct DeviceID {

    private let _vendorID: UInt16
    private let _productID: UInt16
    
    public init(vendorID: UInt16, productID: UInt16) {
        self._vendorID = vendorID
        self._productID = productID
    }

    public var vendorID: UInt16 { return self._vendorID }
    public var productID: UInt16 { return self._productID }
}
