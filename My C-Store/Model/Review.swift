import SwiftUI
import Foundation
import ParseSwift

struct Review: Identifiable, Hashable {
    var id = UUID().uuidString
    var userId: String = ""
    var productName: String = ""
    var content: String = ""
}
