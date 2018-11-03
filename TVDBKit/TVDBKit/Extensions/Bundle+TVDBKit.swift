import Foundation

private class TVDBKitBundleMember {}
extension Bundle {
    static var tvdbKitBundle: Bundle {
        return Bundle(for: TVDBKitBundleMember.self)
    }
}
