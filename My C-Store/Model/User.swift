import SwiftUI
import Foundation
import ParseSwift

struct User: Identifiable, Hashable {
    var id = UUID().uuidString
    var username: String
    var password: String
    var name: String
    var email: String
    var image: String
}
