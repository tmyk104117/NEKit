import Foundation

public enum IPMask {
    case IPv4(UInt32), IPv6(UInt128)

    func mask(baseIP: NEIPAddress) -> (NEIPAddress, NEIPAddress)? {
        switch (self, baseIP.address) {
        case (.IPv4(var m), .IPv4(let addr)):
            guard m <= 32 else {
                return nil
            }

            if m == 32 {
                return (baseIP, baseIP)
            }

            if m == 0 {
                return (NEIPAddress(ipv4InNetworkOrder: 0), NEIPAddress(ipv4InNetworkOrder: UInt32.max))
            }

            m = 32 - m
            let base = (addr.s_addr.byteSwapped >> m) << m
            let end = base | ~((UInt32.max >> m) << m)
            let b = NEIPAddress(ipv4InNetworkOrder: base.byteSwapped)
            let e = NEIPAddress(ipv4InNetworkOrder: end.byteSwapped)
            return (b, e)
        case (.IPv6(var m), .IPv6):
            guard m <= 128 else {
                return nil
            }

            if m == 128 {
                return (baseIP, baseIP)
            }

            if m == 0 {
                return (NEIPAddress(ipv6InNetworkOrder: 0), NEIPAddress(ipv6InNetworkOrder: UInt128.max))
            }

            m = 128 - m
            let base = (baseIP.address.asUInt128.byteSwapped >> m) << m
            let end = base | ~((UInt128.max >> m) << m)
            let b = NEIPAddress(ipv6InNetworkOrder: base.byteSwapped)
            let e = NEIPAddress(ipv6InNetworkOrder: end.byteSwapped)
            return (b, e)
        default:
            return nil
        }
    }
}
