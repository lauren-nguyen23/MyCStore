import SwiftUI
import Parse
import ParseSwift

struct ContentView: View {
    
    @AppStorage("loginStatus") var loginStatus: Bool = false
    @EnvironmentObject var sharedData: SharedDataModel
    
    var body: some View {
        Group {
            if (PFUser.current() == nil || loginStatus == false) {
                OnBoardingPage()
            } else {
                MainPage()
                    .onAppear {
                        print(PFUser.current())
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
