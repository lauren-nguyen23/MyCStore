import SwiftUI
import Foundation
import ParseSwift

struct Order: Identifiable, Hashable {
    var id = UUID().uuidString
    var userId: String = ""
    var total: Double = 0.0
    var date: String = ""
    var status: String = "In progress" // Complete, In progress, Cancelled
}
