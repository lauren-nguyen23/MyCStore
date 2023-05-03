import SwiftUI
import Combine
import Parse
import ParseSwift

class SharedDataModel: ObservableObject {
    //Detail Product Data
    @Published var detailProduct: Product?
    @Published var showDetailProduct: Bool = false
    
    //matched with search string
    @Published var searchMatch: Bool = false
    
    //for Wishlist Page
    
    //Wishlist products
    @Published var favProducts: [Product] = []
    
    //for Cart Page
    
    //Cart products
    @Published var cartTotal: Double = 0.0
    @Published var cartProducts: [Product] = []
    
    //Calculate total price
    func getTotal() -> Double {
        var cartTotal: Double = 0.0
        
        cartProducts.forEach { product in
            let price = product.price
            let quantity = product.quantity
            
            let subtotal = Double(quantity)*price
            
            cartTotal += subtotal
        }
        
        return cartTotal
    }
    
    //for Store Page
    @Published var products: [Product] = [
        Product(name: "Caesar chicken wrap", price: 6.50, image: "chicken_wrap", quantity: 0, rating: 4, reviews: [Review(content: "This is Caesar chicken wrap"), Review(content: "This is awesome"), Review(content: "I have this for lunch everyday"), Review(content: "This is a very long long long long long looooooooooooooooooooooooooooooooooooooooong long long long long long review just to test")]),
        Product(name: "Oatly milk", price: 8.00, image: "oatly_milk", quantity: 0, rating: 3, reviews: [Review(content: "This is Oatly milk"), Review(content: "This is awesome"), Review(content: "I have this for lunch everyday")]),
        Product(name: "Pringles", price: 3.75, image: "pringles", quantity: 0, rating: 5, reviews: [Review(content: "This is Pringles"), Review(content: "This is awesome"), Review(content: "I have this for lunch everyday")]),
        Product(name: "Grapes", price: 7.95, image: "grapes", quantity: 0, rating: 4, reviews: [Review(content: "This is Grapes"), Review(content: "This is awesome"), Review(content: "I have this for lunch everyday")]),
        Product(name: "Yakisoba beef flavor", price: 2.50, image: "yakisoba", quantity: 0, rating: 2, reviews: [Review(content: "This is noodle"), Review(content: "This is awesome"), Review(content: "I have this for lunch everyday")]),
        Product(name: "Kikkoman soy sauce", price: 12.50, image: "soy_sauce", quantity: 0, rating: 5, reviews: [Review(content: "This is soy sauce"), Review(content: "This is awesome"), Review(content: "I have this for lunch everyday")])
    ]
    
    @Published var searchText: String = ""
    @Published var searchActivated: Bool = false
    @Published var searchedProducts: [Product]?
    
    var searchCancellable: AnyCancellable?
    
    init() {
        searchCancellable = $searchText.removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: {str in
                if str != "" {
                    self.filterProductBySearch()
                } else {
                    self.searchedProducts = nil
                }
            })
        parseOrders()
    }
    
    func filterProductBySearch() {
        DispatchQueue.global(qos: .userInteractive).async {
            let results = self.products
                .lazy
                .filter { product in
                    return product.name.lowercased().contains(self.searchText.lowercased())
                }
            DispatchQueue.main.async {
                self.searchedProducts = results.compactMap({product in
                    return product
                })
            }
        }
    }
    
    //for Orders Page
    
    @Published var myOrders: [Order] = []
    
    func parseOrders(){
        myOrders = []
        let query = PFQuery(className:"Order")
        query.whereKey("userId", equalTo: PFUser.current()?.objectId)
        query.findObjectsInBackground { (orders, error) in
            if let orders = orders {
                print("Successfully retrieved \(orders.count) orders.")
                print(orders[0])
                for order in orders {
                    
                    let retrievedOrder = Order(
                        userId: order["userId"] as? String ?? "",
                        total: order["total"] as? Double ?? 0.0,
                        date: self.toString(date: order["date"] as! Date, format: "MMM dd, yyyy"),
                        status: order["status"] as? String ?? ""
                    )
                    self.myOrders.append(retrievedOrder)
                }
                print("These are my orders")
                print(self.myOrders)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func toString(date: Date, format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    //TODO: implement this function
//    func parseProducts() -> [Product]{}
}
