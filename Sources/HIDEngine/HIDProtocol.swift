import Foundation


/*
    in some cases a user may want to parse incoming data and format outgoing data
    or validate data in a certain way that is specefic to a device.

    the implementation of send/receive algorithms in the HIDController class makes a
    check for a parser and a formatter attached to the controller. if a parser and/or 
    formatter exists, data is passed through them before returning incoming data to the
    user or sending outgoing data to the device. if no parser/formatter exists, the 
    controller returns the incoming data as received and sends outgoing data also as
    received from the user.

    users of the library can create device specific parser/formatter by adopting the
    Parser and/or the Formatter protocols. then set these custom parser and formatter
    in the controller using: setParser and setFormatter methods of the controller. this
    will pass the hid data through the custom objects.
*/

public protocol HIDParser {
    func parsed(data: Array<UInt8>) -> Array<UInt8>
}

public protocol HIDFormatter {
    func formatted(data: Array<UInt8>) -> Array<UInt8>
}
