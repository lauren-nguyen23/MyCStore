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
                .onAppear {
                    doParseStuff()
                }
            } else {
                MainPage()
                    .onAppear {
                        doParseStuff()
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

//TODO: comment out later, this is just to test connection at first stage
func doParseStuff(){
    let query = PFQuery(className:"Product") // Initializes a ParseQuery in the Product class
    query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in // executes the query
        if let error = error {  // if there's an error
            // print the error
            print(error.localizedDescription)
        } else if let objects = objects { // if successfuly retrieved
            // print to the console
            print("Successfully retrieved \(objects.count) products.")
            //print(objects[0]["name"])
        }
    }
}
