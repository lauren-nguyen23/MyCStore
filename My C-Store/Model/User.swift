import SwiftUI
import Foundation
import ParseSwift

//struct User: Identifiable, Hashable, ParseUser, ParseObject {
struct User: Identifiable, Hashable {
//    init() {
//
//    }
//
//    // Additional properties required by the ParseUser protocol
//    var authData: [String : [String : String]?]?
//    var originalData: Data?
//    var objectId: String?
//    var createdAt: Date?
//    var updatedAt: Date?
//    var ACL: ParseACL?
    
    // Main properties linked to the user's information
//    var username: String?
//    var email: String?
//    var emailVerified: Bool?
//    var password: String?
    
    var id = UUID().uuidString
    var username: String
    var password: String
    var name: String
    var email: String
    var image: String
    
    //var loggedIn: Bool
    
    // A custom property
    //var image: String?
}
