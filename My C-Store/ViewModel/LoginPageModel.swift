import SwiftUI
import Parse

class LoginPageModel: ObservableObject {
    
    //Login properties
    @Published var username: String = ""
    @Published var password: String = ""
    
    //Login status
    @AppStorage("loginStatus") var loginStatus: Bool = false
    
    //@State private var showingAlert = false
    
    //Login call
    func login() {
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        
        PFUser.logInWithUsername(inBackground: username, password: password) {
            user, error in
            if let error = error {
                print("Error logging in \(error)")
                self.loginStatus = false
                //self.displayAlert(withTitle: "Error", message: "Incorrect username or password")
                
            } else {
                print("User logged in successfully")
                self.loginStatus = true
            }
        }
    }
    
    func displayAlert(withTitle title: String, message: String) {
        //TODO: implement this
    }
}
