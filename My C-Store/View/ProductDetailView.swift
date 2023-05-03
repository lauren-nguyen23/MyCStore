import SwiftUI

struct ProductDetailView: View {
    var product: Product
    
    //Matched Geometry Effect
    var animation: Namespace.ID
    
    //SharedDataModel
    @EnvironmentObject var sharedData: SharedDataModel
    @State private var showingReviews = false
//    @State private var presentReviewInput = false
//    @State private var review: String = ""
    //@Binding var presentMe : Bool
    
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
                    Text("$" + String(format: "%.2f", product.price))
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
                        showingReviews = true
                    } label: {
                        Text("Read reviews")
                            .font(.custom(customFont, size: 18).bold())
                            .foregroundColor(Color("supple"))
                    }
                    .popover(isPresented: $showingReviews) {
                        ReviewsPopover(product: product)
                    }
                }
                .padding([.horizontal, .bottom], 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(0)
            
            //Add to cart button
            Button {
                isAddedToCart() ? print("added already") : addToCart()
            } label: {
                Text(isAddedToCart() ? "Added to Cart" : "Add to Cart")
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
        sharedData.cartProducts.append(product)
        sharedData.cartTotal = sharedData.getTotal()
        if let index = sharedData.cartProducts.firstIndex(where: { product in
            return self.product.id == product.id
        }) {
            sharedData.cartProducts[index].quantity = 1
        }
    }
    
    func removeFromCart() {
        if let index = sharedData.cartProducts.firstIndex(where: { product in
            return self.product.id == product.id
        }) {
            sharedData.cartProducts.remove(at: index)
        }
    }
    
    @ViewBuilder
    func ReviewsPopover(product: Product) -> some View {
        VStack {
            
            HStack (alignment: .top, spacing: 10) {
            
                Text("Reviews")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.top, .leading])
            
                Spacer ()
            
                //button to close popover
                Button  (action: {
                   showingReviews.toggle()
                }, label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.gray)
                })
                .padding([.top, .trailing])
    
            }
            
            //displaying all reviews
            ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(product.reviews) { review in
                            HStack (spacing: 0) {
                                ReviewCardView(review: review)
                            }
                        }
                    }
                    .padding(.top, 25)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func ReviewCardView(review: Review) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(review.content)
                .font(.custom(customFont, size: 18))
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.top, 5)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("off_white"))
        .cornerRadius(20)
        
    }
}


struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
//        ProductDetailView(product: StoreViewModel().products[0])
//            .environmentObject(SharedDataModel())
        MainPage()
    }
}

