import SwiftUI

class LoginPageModel: ObservableObject {
    
    //Login properties
    @Published var email: String = ""
    @Published var password: String = ""
    
    //Login status
    @AppStorage("loginStatus") var loginStatus: Bool = false
    
    //Login call
    func login() {
        withAnimation{
            loginStatus = true
        }
    }
    
    
}
