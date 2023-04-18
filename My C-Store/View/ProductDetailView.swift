import SwiftUI

struct ProductDetailView: View {
    var product: Product
    
    //Matched Geometry Effect
    var animation: Namespace.ID
    
    //SharedDataModel
    @EnvironmentObject var sharedData: SharedDataModel
    
    @EnvironmentObject var storeData: StoreViewModel
    
    var body: some View {
        VStack{
            
            VStack{
                //Title Bar
                HStack{
                
                    //back button
                    Button(action: {
                        withAnimation(.easeInOut) {
                            sharedData.showDetailProduct = false
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(Color.black.opacity(0.7))
                    }
                    
                    Spacer()
                }
                .padding()
                
                //Product Image
                Image(product.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .matchedGeometryEffect(id: "\(product.id)IMAGE", in: animation)
                    .padding(.horizontal)
                    .frame(maxHeight: .infinity)
                
                Spacer()
                    
            }
            .frame(height: UIScreen.main.bounds.height/2.7)
            .background(Color("off_white"))
            .zIndex(1)

            ScrollView(.vertical, showsIndicators: false) {
                //Product data
                VStack (alignment: .center, spacing: 15){
                    //Product name
                    Text(product.name)
                        .font(.title)
                    
                    //Product price
                    Text(product.price)
                        .font(.title2.bold())
                    
                    //Quantity and Wishlist Button
//                    HStack {
//                        //- Quantity +
//                        HStack(spacing: 10) {
//                            Button {
//                                removeFromCart()
//                            } label: {
//                                Image(systemName: "minus")
//                                    .font(.body.bold())
//                                    .foregroundColor(Color("supple"))
//                                    .frame(width: 30, height: 30)
//                                    .background(Color("powder"))
//                                    .cornerRadius(15)
//                            }
//
//                            Text("\(product.quantity)")
//                                .font(.custom(customFont, size: 22))
//                                .fontWeight(.semibold)
//                                .foregroundColor(.black)
//
//                            Button {
//                                addToCart()
//                            } label: {
//                                Image(systemName: "plus")
//                                    .font(.body.bold())
//                                    .foregroundColor(Color("supple"))
//                                    .frame(width: 30, height: 30)
//                                    .background(Color("powder"))
//                                    .cornerRadius(15)
//                            }
//                        }
//                        .padding(.horizontal, 15)
                        
                        //Liked Button
                        Button {
                            addToWishlist()
                        } label: {
                            Image("Wishlist")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(isInWishlist() ? .red : .gray.opacity(0.7))
                        }
                    //}
                    
                    //Rating display
                    //TODO: add function to color the stars
                    HStack {
//                        Image(systemName: "star")
//                        Image(systemName: "star")
//                        Image(systemName: "star")
//                        Image(systemName: "star")
//                        Image(systemName: "star")
                        RatingView(rating: product.rating)
                        
                        Text("\(String(product.rating))" + " (" + "\(product.quantity)" + ")")
                    }
                    
                    //Rate and Review Buttons
                    HStack {
                        
                        //Rate button
                        Button {
                            //TODO: add rate function
                        } label: {
                            Text("Rate")
                                .font(.title3.bold())
                                .frame(width: 100, height: 40)
                                .foregroundColor(.white)
                                .background(Color("supple"))
                                .cornerRadius(50)
                        }
                        
                        //Review button
                        Button {
                            //TODO: add review function
                        } label: {
                            Text("Review")
                                .font(.title3.bold())
                                .frame(width: 100, height: 40)
                                .foregroundColor(.white)
                                .background(Color("supple"))
                                .cornerRadius(50)
                        }
                        
                    }
                
                    Button {
                        //TODO: show reviews
                    } label: {
                        Text("Read reviews")
                            .font(.custom(customFont, size: 18).bold())
                            .foregroundColor(Color("supple"))
                    }
                    
                    
                }
                .padding([.horizontal, .bottom], 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(0)
            
            //Add to cart button
            Button {
                
            } label: {
                Text("Add to Cart")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .foregroundColor(.white)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .background(Color("supple")
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.06), radius: 5, x: 5, y: 5))
            }
            .padding(.horizontal, 20)
        }
        .animation(.easeInOut, value: sharedData.favProducts)
        .animation(.easeInOut, value: sharedData.cartProducts)
        .background(.white)
    }
    
    func addToWishlist() {
        if let index = sharedData.favProducts.firstIndex(where: { product in
            return self.product.id == product.id
        }) {
            //remove from Wishlist
            sharedData.favProducts.remove(at: index)
        } else {
            //add to Wishlist
            sharedData.favProducts.append(product)
        }
    }
    
    func isInWishlist() -> Bool {
        return sharedData.favProducts.contains { product in
            return self.product.id == product.id
        }
    }
    
    func isAddedToCart() -> Bool {
        return sharedData.cartProducts.contains { product in
            return self.product.id == product.id
        }
    }
    
    func addToCart() {
        if let index = sharedData.favProducts.firstIndex(where: { product in
            return self.product.id == product.id
        }) {
            //remove from Cart
            sharedData.cartProducts.remove(at: index)
        } else {
            //add to Cart
            sharedData.cartProducts.append(product)
        }
    }
    
    func removeFromCart() {
        
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
//        ProductDetailView(product: StoreViewModel().products[0])
//            .environmentObject(SharedDataModel())
        MainPage()
    }
}
