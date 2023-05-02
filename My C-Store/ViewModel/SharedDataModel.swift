import SwiftUI
import Combine

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
    @Published var cartTotal: Double = 0.00
    @Published var cartProducts: [Product] = []
    
    //Calculate total price
    func getTotal() -> Double {
        var cartTotal: Double = 0.00
        
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
        Product(name: "Caesar chicken wrap", price: 6.50, image: "chicken_wrap", quantity: 0, rating: 4),
        Product(name: "Oatly milk", price: 8.00, image: "oatly_milk", quantity: 0, rating: 3),
        Product(name: "Pringles", price: 3.75, image: "pringles", quantity: 0, rating: 5),
        Product(name: "Grapes", price: 7.95, image: "grapes", quantity: 0, rating: 4),
        Product(name: "Yakisoba beef flavor", price: 2.50, image: "yakisoba", quantity: 0, rating: 2),
        Product(name: "Kikkoman soy sauce", price: 12.50, image: "soy_sauce", quantity: 0, rating: 5)
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
    @Published var orders: [Order] = [
        Order(total: 24.95, date: "Mar 8, 2023", status: "In progress"),
        Order(total: 10.35, date: "Feb 24, 2023", status: "Complete"),
        Order(total: 4.85, date: "Feb 2, 2023", status: "Complete")
    ]
}
