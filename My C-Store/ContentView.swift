import SwiftUI

struct ContentView: View {
    
    @AppStorage("loginStatus") var loginStatus: Bool = false
    
    var body: some View {
        Group {
            //Testing
            //OnBoardingPage()
            
            //TODO: uncomment to test
            if loginStatus {
                MainPage()
            } else {
                OnBoardingPage()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
