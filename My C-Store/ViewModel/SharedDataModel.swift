import SwiftUI

class SharedDataModel: ObservableObject {
    //Detail Product Data
    @Published var detailProduct: Product?
    @Published var showDetailProduct: Bool = false
    
    //matched with search string
    @Published var searchMatch: Bool = false
    
    //Wishlist product
    @Published var favProducts: [Product] = [
//        Product(name: "Caesar chicken wrap", price: "$6.50", image: "chicken_wrap"),
//        Product(name: "Pringles", price: "$3.75", image: "pringles"),
//        Product(name: "Oatly milk", price: "$8.00", image: "oatly_milk")
    ]
    
    //Cart product
    @Published var cartProducts: [Product] = [
        Product(name: "Caesar chicken wrap", price: "$6.50", image: "chicken_wrap", quantity: 1),
        Product(name: "Pringles", price: "$3.75", image: "pringles",  quantity: 3),
        Product(name: "Oatly milk", price: "$8.00", image: "oatly_milk", quantity: 1)
    ]
    
    //Calculate total price
    func getTotal() -> String {
        //TODO: convert total to Double
        var total: Int = 0
        
        cartProducts.forEach { product in
            let price = product.price.replacingOccurrences(of: "$", with: "") as NSString
            let quantity = product.quantity
            
            let subtotal = quantity*price.integerValue
            
            total += subtotal
        }
        
        return "$\(total)"
    }
}
