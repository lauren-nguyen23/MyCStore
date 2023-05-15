import SwiftUI
import Parse

class LoginPageModel: ObservableObject {
    
    // Login properties
    @Published var username: String = ""
    @Published var password: String = ""
    
    // Login status
    @AppStorage("loginStatus") var loginStatus: Bool = false
    
    // Login call
    func login() {
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        
        PFUser.logInWithUsername(inBackground: username, password: password) {
            user, error in
            if let error = error {
                print("Error logging in \(error)")
                self.loginStatus = false
                
            } else {
                print("User logged in successfully")
                self.loginStatus = true
            }
        }
    }
}
