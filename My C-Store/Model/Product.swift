import SwiftUI
import Foundation
import ParseSwift

struct Product: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String = ""
    var price: Double = 0.0
    var image: String = ""
    var quantity: Int = 0 // quantity in cart
    
    var rating: Double = 0.0
    var reviews: [Review] = []
}
