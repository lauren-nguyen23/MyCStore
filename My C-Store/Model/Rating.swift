import SwiftUI
import Foundation
import ParseSwift

struct Rate: Identifiable, Hashable {
    var id = UUID().uuidString
    var productName: String = ""
    var rating: Double = 0.0
}
