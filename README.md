# HIDEngine

## overview ##

This package is a Swift interface into C-library "hidapi" designed to *swiftify* working with HID devices. The product of this package is a dynamic library. Users of the library must import HIDEngine into thier projects.

---

## How to use the library ##
Add this swift package to your Xcode project. Users of the library can **inistantiate** *HIDControlleror* with a device's vendor and product ids which will enable:

    - access to hid interface of usb devices 
    - inspecting device information
    - sending and receiving hid data to and from a usb device

Users of the library can also choose to **subclass** *HIDController*, which will similarly enable the above and allow for writing code that is specific to the device at hand.

---
## Platform ##
This package has been devoloped on **macOS v10.15** and requires macOS v10.15 as minimum OS requirement.

---
## Required ##
These libraries must be installed on your system. Using homebrew is the easyest way to install:

    - libtool
    - hidapi

    in terminal: brew install libtool hidapi

---
## What the library offers ##
The library takes care in the background of managing the library objects and the **memory management** associated with C-library hidapi. examples of what is automatically taken care of:

    - searching the system for a device
    - initializing and releasing hidapi library
    - opening and closing a device
  
with the vendor and product IDs of a device, users of the library can query the device properties and **send/receive data** to and from a device.  

Device properties include:

    - vendor id
    - product id
    - device path
    - device name
    - device manufacturer name
    - device serial number 
    - and more.

---
## Modularity ##

In some cases a user may want to **parse** incoming data and **format** outgoing data or validate data in a certain way that is specefic to a device.

The implementation of send/receive algorithms in the HIDController class makes a check to see if a parser and/or a formatter are attached to the controller. if a parser and/or formatter exists, data is passed through them before returning incoming data to the user or sending outgoing data to the device. if no parser/formatter exists, the controller returns the incoming data as received and sends outgoing data also as received from the user.

Users of the library can create device specific parser/formatter by adopting the **HIDParser** and/or the **HIDFormatter** protocols. then set these custom parser and formatter in the controller using: **setParser** and **setFormatter** methods of the controller. this will pass the hid data through the custom parser/formatter objects.


## Example ##

    import HIDEngine

    /* use utility function to print information about every hid device attached to the computer */
    
    displayAllAttachedHidDevices()

    // to work with a specific device 
    
    /* inistantiaate a controller instance with device ids */
    if let controller = HIDController(vendorID: XXXX, productID: XXXX)  {
        
        /* query the device properties */
        print("found controller for device \(controller.productString!)")
        print("vendor id: \(controller.vendorID!)")
        print("product id: \(controller.productID!)")
        print("manufacturer: \(controller.manufacturerString!)")
        print("serial number: \(controller.serialNumber!)")
        print("release number: \(controller.releaseNumber!)")
        print("usage page: \(controller.usagePage!)")
        print("usage: \(controller.usage!)")
        print("path: \(controller.path!)")
        print("interface number: \(controller.interfaceNumber!)")

        /* create app loop */
        outerLoop: while true {

            /* receive and print data from device */
            let data = controller.receive()
            print(data)
            // print(data.count)
            
            /* break out of the app loop with a condition */
            if CONDITION {
                break outerLoop
            }
        }
    } else {
        print("Device not found")
    }