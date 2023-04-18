import SwiftUI

struct CartPage: View {
    
    //@EnvironmentObject var sharedData: SharedDataModel
    @StateObject var sharedData: SharedDataModel = SharedDataModel()
    
    var body : some View{
        
        NavigationView {
                VStack {
                    HStack {
                        Text("Cart")
                            .font(.title)
                            .foregroundColor(Color.black)
                        
                        Spacer()
                        
                        //Account button
                        Button(action: {
                            
                        }) {
                                Image("Account")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                        }
                        
                    }
                    .padding(15)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                    //check if cart is empty
                    if sharedData.cartProducts.isEmpty {
                        Group {
                            Text("Your cart is empty")
                                .font(.custom(customFont, size: 20))
                                .fontWeight(.semibold)
                        }
                    } else {
                        //displaying all products in cart
                        VStack(spacing: 15) {
                            ForEach($sharedData.cartProducts) { $product in
                                HStack (spacing: 0) {
                                    ProductCardView(product: $product)
                                }
                            }
                        }
                        .padding(.top, 25)
                        .padding(.horizontal)
                    }
                }
                .padding()
                    
                    //Showing Total of cart and Checkout button
                    VStack(spacing: 0) {
                        //Total
                        Text(sharedData.getTotal())
                            .font(.custom(customFont, size: 25).bold())
                            .foregroundColor(.black)
                        
                        //Checkout button
                        Button {
                            //TODO: add checkout function to proceed to Checkout screen
                        } label: {
                            Text("Check Out")
                                .font(.custom(customFont, size: 18).bold())
                                .foregroundColor(.white).padding(.vertical, 20)
                                .frame(maxWidth: 170, maxHeight: 45)
                                .background(Color("supple"))
                                .cornerRadius(50)
                                .padding(.vertical, 20)
                        }
                        .padding(0)
                        .padding(.horizontal)
                    }
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
        }
    }
}

struct CartPage_Previews: PreviewProvider {
    static var previews: some View {
        CartPage()
            //.environmentObject(SharedDataModel())
    }
}

struct ProductCardView: View {
    
    @Binding var product: Product
    
    var body : some View{
    
    HStack(spacing: 15) {
        Image(product.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
        
        VStack(alignment: .leading, spacing: 8) {
            Text(product.name)
                .font(.custom(customFont, size: 18).bold())
                .lineLimit(1)
            
            //Quantity buttons
            HStack(spacing: 10) {
                Button {
                    product.quantity = (product.quantity > 0 ? (product.quantity - 1) : 0)
                } label: {
                    Image(systemName: "minus")
                        .font(.caption.bold())
                        .foregroundColor(Color("supple"))
                        .frame(width: 20, height: 20)
                        .background(Color("powder"))
                        .cornerRadius(15)
                }
                
                Text("\(product.quantity)")
                    .font(.custom(customFont, size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Button {
                    product.quantity += 1
                } label: {
                    Image(systemName: "plus")
                        .font(.caption.bold())
                        .foregroundColor(Color("supple"))
                        .frame(width: 20, height: 20)
                        .background(Color("powder"))
                        .cornerRadius(15)
                }
            }
        }
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 10)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
        Color("tile_bg")
            .cornerRadius(20)
    )
}
}
