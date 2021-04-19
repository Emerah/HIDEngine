import Foundation

internal extension String {
    // takes a pointer to wchar_t [32bit] and returns a String
    init?(wcString: UnsafeMutablePointer<wchar_t>, encoding: String.Encoding = .utf32LittleEndian) {
        let byteCount = wcslen(wcString) * MemoryLayout<wchar_t>.stride
        let data = Data.init(bytes: wcString, count: byteCount)
        self.init(data: data, encoding: encoding)
    }
}