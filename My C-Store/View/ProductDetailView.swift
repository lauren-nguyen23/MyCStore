import SwiftUI
import Parse
import ParseSwift

struct ProductDetailView: View {
    var product: Product
    
    // Matched Geometry Effect
    var animation: Namespace.ID
    
    // SharedDataModel
    @EnvironmentObject var sharedData: SharedDataModel
    @State private var showingReviews = false
    @State private var showingReviewTextField = false
    @State private var reviewInput: String = ""
    @State private var listReviews: [Review] = []
    @State private var showingRatingTextField = false
    @State private var userRating: Double = 0.0
    @State private var currRating: Double = 5.0
    
    var body: some View {
        VStack{
            
            VStack{
                // Title bar
                HStack{
                
                    // Back button
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
                
                // Product image
                AsyncImage(url: URL(string: product.image)!, content: { image in
                  image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }, placeholder: {
                    Color.gray
                })
                .matchedGeometryEffect(id: "\(product.id)IMAGE", in: animation)
                .padding(.horizontal)
                .frame(maxHeight: .infinity)
                
                Spacer()
                    
            }
            .frame(height: UIScreen.main.bounds.height/2.7)
            .background(Color("off_white"))
            .zIndex(1)

            ScrollView(.vertical, showsIndicators: false) {
                // product data
                VStack (alignment: .center, spacing: 15){
                    // product name
                    Text(product.name)
                        .font(.title)
                    
                    // product price
                    Text("$" + String(format: "%.2f", product.price))
                        .font(.title2.bold())
                        
                        // Wishlist Button
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
                    
                    // show current overall rating
                    HStack {
                        Text("Rating by other users: ")
                        
                        // load rating from database
                        Text("\(String(format: "%.1f", loadCurrentRatings()))" + " / 5")
                    }
                    
                    // Rate and Review Buttons
                    HStack {
                        
                        // Rate button
                        Button {
                            showingRatingTextField.toggle()
                        } label: {
                            Text("Rate")
                                .font(.title3.bold())
                                .frame(width: 100, height: 40)
                                .foregroundColor(.white)
                                .background(Color("supple"))
                                .cornerRadius(50)
                        }
                        .popover(isPresented: $showingRatingTextField) {
                            RateInputPopover(product: product)
                        }
                        
                        // Review button
                        Button {
                            showingReviewTextField.toggle()
                        } label: {
                            Text("Review")
                                .font(.title3.bold())
                                .frame(width: 100, height: 40)
                                .foregroundColor(.white)
                                .background(Color("supple"))
                                .cornerRadius(50)
                        }
                        .popover(isPresented: $showingReviewTextField) {
                            ReviewInputPopover(product: product)
                        }
                        
                    }
                
                    Button {
                        readReviews(productName: product.name)
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
            
            // Add to Cart button
            Button {
                isAddedToCart() ? print("Added already") : addToCart()
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
            .disabled(isAddedToCart())
        }
        .animation(.easeInOut, value: sharedData.favProducts)
        .animation(.easeInOut, value: sharedData.cartProducts)
        .background(.white)
    }
    
    func addToWishlist() {
        if let index = sharedData.favProducts.firstIndex(where: { product in
            return self.product.id == product.id
        }) {
            // remove from Wishlist
            sharedData.favProducts.remove(at: index)
        } else {
            // add to Wishlist
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
    
    func readReviews(productName: String){
        listReviews = []
        let query = PFQuery(className:"ItemReview")
        query.whereKey("productName", equalTo: productName)
        query.findObjectsInBackground { (reviews, error) in
            if let reviews = reviews {
                print("Successfully retrieved \(reviews.count) reviews.")
                for review in reviews {
                    let retrievedReview = Review(
                        productName: review["productName"] as? String ?? "",
                        content: review["content"] as? String ?? ""
                    )
                    listReviews.append(retrievedReview)
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    
    func submitReview(productName: String, content: String) {
        let review = PFObject(className: "ItemReview")
        review["productName"] = productName
        review["content"] = content
        
        review.saveInBackground { (success, error) in
            if success {
                print("Review submitted!")
            } else {
                print("Error submitting review!")
            }
        }
    }
    
    func submitRating(productName: String, userRating: Double) {
        // save Rating
        let rating = PFObject(className: "Rating")
        rating["productName"] = productName
        rating["rating"] = userRating
        
        rating.saveInBackground { (success, error) in
            if success {
                print("Rating submitted!")
            } else {
                print("Error submitting rating!")
            }
        }
        
        // query all existing ratings to count number of current ratings
        var numRatings = 0
        let queryRating = PFQuery(className:"Rating")
        queryRating.whereKey("productName", equalTo: productName)
        queryRating.findObjectsInBackground { (ratings, error) in
            if let ratings = ratings {
                for rating in ratings {
                    numRatings += 1
                }
            } else {
                print(error?.localizedDescription)
            }
        }
        
        // query products to take curr rating
        let query = PFQuery(className:"Product")
        query.whereKey("name", equalTo: productName)
        query.findObjectsInBackground { (product, error) in
            if let product = product {
                var currentRating = product[0]["rating"] as! Double ?? 0.0
                
                // update the rating property
                product[0]["rating"] = (userRating + currentRating*Double(numRatings-1))/Double(numRatings)
                
                // save changes synchronously
                product[0].saveInBackground()
                
                self.currRating = product[0]["rating"] as! Double ?? 0.0
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func loadCurrentRatings() -> Double {
        let query = PFQuery(className:"Product")
        query.whereKey("name", equalTo: product.name)
        query.findObjectsInBackground { (product, error) in
            if let product = product {
                self.currRating = product[0]["rating"] as! Double ?? 0.0
            }
        }
        return self.currRating
    }
    
    @ViewBuilder
    func RateInputPopover(product: Product) -> some View {
        VStack {
            
            HStack (alignment: .top, spacing: 10) {
            
                Text("Your Rating")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.top, .leading])
            
                Spacer ()
            
                // button to close popover
                Button  (action: {
                   showingRatingTextField.toggle()
                }, label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color("supple"))
                })
                .padding([.top, .trailing])
    
            }
            
            Spacer()
            
            // taking rating input
            Text("Insert your rating below:")
            
            RatingView(maxRating: 5, rating: $userRating)
                            .padding(.bottom, 20)
                            .padding(.top, 20)
                        
            Text("Rating: \(userRating, specifier: "%.1f")")
            
            Spacer()
            
            Button (action: {
                submitRating(productName: product.name, userRating: userRating)
                showingRatingTextField.toggle()
            }, label: {
                Text("Submit rating")
                    .font(.custom(customFont, size: 18).bold())
                    .foregroundColor(.white).padding(.vertical, 20)
                    .frame(maxWidth: 170, maxHeight: 45)
                    .background(Color("supple"))
                    .cornerRadius(50)
                    .padding(.vertical, 20)
            })
            .padding(0)
            .padding(.horizontal)
            
        }
    }
    
    @ViewBuilder
    func ReviewInputPopover(product: Product) -> some View {
        VStack {
            
            HStack (alignment: .top, spacing: 10) {
            
                Text("Your Review")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.top, .leading])
            
                Spacer ()
            
                // button to close popover
                Button  (action: {
                   showingReviewTextField.toggle()
                }, label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color("supple"))
                })
                .padding([.top, .trailing])
    
            }
            
            Spacer()
            
            Text("Insert your review below:")
            
            // take review input
            ZStack {
                TextEditor(text: $reviewInput)
                Text(reviewInput).opacity(0).padding(.all, 8)
            }
            .shadow(radius: 1)
            .frame(width: 350, height: 200)
            
            Spacer()
            
            // submit review
            Button (action: {
                submitReview(productName: product.name, content: reviewInput)
                showingReviewTextField.toggle()
            }, label: {
                Text("Submit review")
                    .font(.custom(customFont, size: 18).bold())
                    .foregroundColor(.white).padding(.vertical, 20)
                    .frame(maxWidth: 170, maxHeight: 45)
                    .background(Color("supple"))
                    .cornerRadius(50)
                    .padding(.vertical, 20)
            })
            .padding(0)
            .padding(.horizontal)
            
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
            
                // button to close popover
                Button  (action: {
                   showingReviews.toggle()
                }, label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color("supple"))
                })
                .padding([.top, .trailing])
    
            }
            
            // displaying all reviews
            ScrollView(.vertical, showsIndicators: false) {
                // checking if there are any reviews at all
                if listReviews.isEmpty {
                    VStack {
                        Text("No reviews yet")
                            .font(.custom(customFont, size: 20))
                            .fontWeight(.semibold)

                        Text("Please add your own review for this product by clicking the Review button.")
                            .font(.custom(customFont, size: 18))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    // displaying all reviews
                    VStack(spacing: 15) {
                        ForEach(listReviews) { review in
                            HStack (spacing: 0) {
                                ReviewCardView(review: review)
                            }
                        }
                    }
                    .padding(.top, 25)
                    .padding(.horizontal)
                }
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
        MainPage()
    }
}

