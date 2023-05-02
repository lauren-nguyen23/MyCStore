import SwiftUI

struct Product: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    //var description: String = ""
    var price: Double = 0.0
    var image: String = ""
    var quantity: Int = 1 //?
    
    //TODO: add reviews and rating properties
    var rating: Int = 0
    var reviews: [String] = []
}
