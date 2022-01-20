import Foundation
import CocoaLumberjackSwift

/**
 The pool is build to hold fake ips.
 
 - note: It is NOT thread-safe.
 */
public final class IPPool {
    let family: NEIPAddress.Family
    let range: IPRange
    var currentEnd: NEIPAddress
    var pool: [NEIPAddress] = []

    public init(range: IPRange) {
        family = range.family
        self.range = range

        currentEnd = range.startIP
    }

    func fetchIP() -> NEIPAddress? {
        if pool.count == 0 {
            if range.contains(ip: currentEnd) {
                defer {
                    currentEnd = currentEnd.advanced(by: 1)!
                }
                return currentEnd
            } else {
                return nil
            }
        }

        return pool.removeLast()
    }

    func release(ip: NEIPAddress) {
        guard ip.family == family else {
            return
        }

        pool.append(ip)
    }

    func contains(ip: NEIPAddress) -> Bool {
        return range.contains(ip: ip)
    }
}
