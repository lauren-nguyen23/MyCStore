import SwiftUI
import Foundation
import ParseSwift

//struct Order: Identifiable, Hashable, ParseObject {
struct Order: Identifiable, Hashable {
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
    var userId: String = ""
    var total: Double = 0.0
    var date: String = ""
    //Complete, In progress, Cancelled
    var status: String = "In progress"
}
