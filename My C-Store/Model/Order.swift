import SwiftUI

struct Order: Identifiable, Hashable {
    var id = UUID().uuidString
    var userId: String = ""
    var total: Double = 0.0
    var date: String = ""
    //Complete, In progress, Cancelled
    var status: String
}
