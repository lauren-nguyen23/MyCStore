import SwiftUI
import Combine
import Parse
import ParseSwift

class SharedDataModel: ObservableObject {
    // Detail Product Data
    @Published var detailProduct: Product?
    @Published var showDetailProduct: Bool = false
    
    // matched with search string
    @Published var searchMatch: Bool = false
    
    // Wishlist
    @Published var favProducts: [Product] = []
    
    // Cart
    @Published var cartTotal: Double = 0.0
    @Published var cartProducts: [Product] = []
    
    // Calculate total price
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
    
    // Store products
    @Published var products: [Product] = []
    
    func parseProducts(){
        let query = PFQuery(className:"Product")
        query.findObjectsInBackground { (products, error) in
            if let products = products {
                print("Successfully retrieved \(products.count) products.")
                for product in products {
                    let imageFile = product["image"] as! PFFileObject
                    let urlString = imageFile.url!
                        
                    let retrievedProduct = Product(
                        name: product["name"] as? String ?? "",
                        price: product["price"] as? Double ?? 0.0,
                        image: urlString,
                        rating: product["rating"] as? Double ?? 0.0
                    )
                    self.products.append(retrievedProduct)
                }
                print("These are my products")
                print(self.products)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
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
        parseProducts()
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
    
    // for Orders Page
    @Published var myOrders: [Order] = []
    
    func parseOrders(){
        self.myOrders = []
        let query = PFQuery(className:"Order")
        query.whereKey("userId", equalTo: PFUser.current()?.objectId)
        query.findObjectsInBackground { (orders, error) in
            if let orders = orders {
                print("Successfully retrieved \(orders.count) orders.")
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
}
