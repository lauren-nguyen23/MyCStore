import SwiftUI
import Foundation
import ParseSwift

//struct Product: Identifiable, Hashable, ParseObject {
struct Product: Identifiable, Hashable {
//    var originalData: Data?
//
//    init() {
//    }
//
//    var objectId: String?
//
//    var createdAt: Date?
//
//    var updatedAt: Date?
//
//    var ACL: ParseACL?
    
    var id = UUID().uuidString
    var name: String = ""
    //TODO: add var description: String = ""
    var price: Double = 0.0
    var image: String = ""
    var quantity: Int = 0 //in cart only
    
    //TODO: rating should be double
    var rating: Int = 0
    var reviews: [Review] = []
}
