import SwiftUI

struct Review: Identifiable, Hashable {
    var id = UUID().uuidString
    var userId: String = ""
    var content: String = ""
}
