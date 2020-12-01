import Foundation

private class TestBundleMember {}
extension Bundle {
    static var testBundle: Bundle {
        return Bundle(for: TestBundleMember.self)
    }
}
