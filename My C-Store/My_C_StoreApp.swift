import SwiftUI
import Parse

@main
struct My_C_StoreApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        print("Configuring Parse...")
        // Prepare Parse configuration
        let parseConfig = ParseClientConfiguration {
            $0.applicationId = "7qenCQe4LFIIfcQEV3KqW1xbbCbusakp6QsCeOwB"
            $0.clientKey = "Um2Uo5NsYG5CCpjKDPTKWlPtGDS47Q0pt5Rq8mrf"
            $0.server = "https://parseapi.back4app.com/" // Parse Server URL
        }
                
        // Initializes Parse with the created Configuration
        Parse.initialize(with: parseConfig)
        print("Parse configured...")
    }
}
