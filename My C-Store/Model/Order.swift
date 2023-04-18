import SwiftUI

struct Order: Identifiable, Hashable {
    var id = UUID().uuidString
    //var userId: String
    var products: String = ""
    var total: String
    var numItems: Int = 0
    var date: String = ""
    var status: String
}
