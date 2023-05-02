import SwiftUI

struct CartPage: View {
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    //Delete option
    @State var showDeleteOption: Bool = false
    
    var body : some View{
        VStack {
            HStack {
                Text("Cart")
                    .font(.system(size: 40))
                    .foregroundColor(Color.black)
                
                Spacer()
                
                //Remove from Cart button
                Button {
                    withAnimation{
                        showDeleteOption.toggle()
                    }
                } label: {
                    Image("delete")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                }
                .opacity(sharedData.cartProducts.isEmpty ? 0 : 1)
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
                                if showDeleteOption {
                                    Button {
                                        deleteProduct(product: product)
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.red)
                                    }
                                    .padding(.trailing)
                                }
                                ProductCardView(product: product)
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
                Text("$" + String(format: "%.2f", sharedData.getTotal()))
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
    
    @ViewBuilder
    func ProductCardView(product: Product) -> some View {
        
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
                        if let index = sharedData.cartProducts.firstIndex(where: { prod in
                            return prod.id == product.id
                        }) {
                            if (sharedData.cartProducts[index].quantity == 1) {
                                //sharedData.cartProducts.remove(at: index)
                                withAnimation{
                                    sharedData.cartProducts.remove(at: index)
                                }
                            } else {
                                sharedData.cartProducts[index].quantity -= 1
                            }
                        }
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
                        if let index = sharedData.cartProducts.firstIndex(where: { prod in
                            return prod.id == product.id
                        }) {
                            sharedData.cartProducts[index].quantity += 1
                        }
                        
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
            .onTapGesture {
                withAnimation(.easeInOut) {
                    sharedData.detailProduct = product
                    sharedData.showDetailProduct = true
                }
            }
        }
        
    
    func deleteProduct(product: Product) {
        if let index = sharedData.cartProducts.firstIndex(where: { currentProduct in
            return product.id == currentProduct.id
        }){
            let _ = withAnimation{
                sharedData.cartProducts.remove(at: index)
            }
        }
    }
}

struct CartPage_Previews: PreviewProvider {
    static var previews: some View {
        CartPage()
            .environmentObject(SharedDataModel())
    }
}
