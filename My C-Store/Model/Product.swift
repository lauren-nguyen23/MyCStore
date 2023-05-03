import SwiftUI

struct Product: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    //TODO: add var description: String = ""
    var price: Double = 0.0
    var image: String = ""
    var quantity: Int = 0 //in cart only
    
    //TODO: add reviews and rating properties; review should be double
    var rating: Int = 0
    var reviews: [Review] = []
}
