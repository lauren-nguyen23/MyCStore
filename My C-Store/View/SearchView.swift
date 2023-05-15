import SwiftUI

struct SearchView: View {
    
    var animation: Namespace.ID
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    // Activating Text Field
    @FocusState var startIF: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: 20) {
                
                // Close button
                Button {
                    withAnimation{
                        sharedData.searchActivated = false
                    }
                    sharedData.searchText = ""
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black.opacity(0.7))
                }
                
                // Search bar
                HStack(spacing: 15){
                        
                        Image(systemName: "magnifyingglass").font(.body)
                        .padding()
                        
                        TextField("Search", text:
                                  $sharedData.searchText)
                            .focused($startIF)
                            .textCase(.lowercase)
                            .disableAutocorrection(true)
                }
                .background(
                    
                    Capsule()
                        .strokeBorder(Color("supple"), lineWidth: 1)
                )
                .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                .padding(.trailing, 20)
                .padding(.bottom, 10)
                    
            }
            
            // showing progress if searching, else showing no results found if empty
            if let products = sharedData.searchedProducts{
                if products.isEmpty {
                    // No Results Found Text
                    VStack(spacing: 10) {
                        Text("Item not found")
                            .font(.custom(customFont, size: 22).bold())
                    }
                    .padding()
                } else {
                    // filter results
                    
                        VStack(spacing: 0) {
                            
                            // Found ... results text
                            Text("Found \(products.count)" + " results")
                                .font(.custom(customFont, size: 24).bold())
                                .padding(.vertical)
                            ScrollView(.vertical, showsIndicators: false){
                                // staggered grid
                                StaggeredGrid(columns: 2, spacing: 5, list: products) { product in
                                    ProductTileView(product: product)
                                }
                            }
                        }
                        .padding()
                }
            } else {
                
                ProgressView()
                    .padding(.top, 30)
                    .opacity(sharedData.searchText == "" ? 0 : 1)
            }

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.white).ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startIF = true
            }
        }
    }
    
    @ViewBuilder
    func ProductTileView(product: Product) -> some View {
        VStack(spacing: 10) {
            
            Image(product.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 110, height: 90)
                .padding(.top, 20)
            
            Text(product.name)
                .font(.custom(customFont, size: 10))
                .fontWeight(.semibold)
                .foregroundColor(.black.opacity(0.70))
                .padding(0)
            
            Text("$" + String(format: "%.2f", product.price))
                .font(.custom(customFont, size: 10))
                .fontWeight(.bold)
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 22)
        .background(
            Color("tile_bg")
                .cornerRadius(25)
                .frame(width: 154, height: 160)
        )
        // when tapped, show the ProductDetailView
        .onTapGesture {
            withAnimation(.easeInOut) {
                sharedData.detailProduct = product
                sharedData.showDetailProduct = true
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
