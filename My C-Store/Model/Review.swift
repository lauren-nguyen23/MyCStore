import SwiftUI
import Foundation
import ParseSwift

//struct Review: Identifiable, Hashable, ParseObject {
struct Review: Identifiable, Hashable {
    var id = UUID().uuidString
    //TODO: is this necessary?
    var userId: String = ""
    var content: String = ""
}
