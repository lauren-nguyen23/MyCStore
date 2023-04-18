import SwiftUI

struct WishlistPage: View {
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    //Delete option
    @State var showDeleteOption: Bool = false
    
    var body: some View {
        NavigationView {
            //ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        Text("Wishlist")
                            .font(.custom(customFont, size: 28).bold())
                        
                        Spacer()
                        
                        //Remove from Wishlist button
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
                        .opacity(sharedData.favProducts.isEmpty ? 0 : 1)
                        
                    }
                    .padding(15)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                    //checking if like products are empty
                    if sharedData.favProducts.isEmpty {
                        
                        Group {
                            Text("Your wishlist is empty")
                                .font(.custom(customFont, size: 20))
                                .fontWeight(.semibold)

                            Text("Click on the heart-shaped icon on each Product Detail Page to save items to your wishlist.")
                                .font(.custom(customFont, size: 18))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                .padding(.top, 10)
                                .multilineTextAlignment(.center)
                        }
                        
                    } else {
                        //displaying all favs
                        VStack(spacing: 15) {
                            ForEach(sharedData.favProducts) {product in
                                HStack(spacing: 0) {
                                    
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
                                    
                                    CardView(product: product)
                                }
                            }
                        }
                        .padding(.top, 25)
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
        }
    }
    
    @ViewBuilder
    func CardView(product: Product) -> some View {
        HStack(spacing: 15) {
            Image(product.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.custom(customFont, size: 18).bold())
                    .lineLimit(1)
                
                Text(product.price)
                    .font(.custom(customFont, size: 17))
                    .fontWeight(.semibold)
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
        if let index = sharedData.favProducts.firstIndex(where: { currentProduct in
            return product.id == currentProduct.id
        }){
            let _ = withAnimation{
                //removing
                sharedData.favProducts.remove(at: index)
            }
        }
    }
}

struct Wishlist_Previews: PreviewProvider {
    static var previews: some View {
        WishlistPage()
            .environmentObject(SharedDataModel())
    }
}
