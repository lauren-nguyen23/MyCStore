import SwiftUI
import Parse
import ParseSwift

struct StorePage: View {
    
    var animation: Namespace.ID
    
    @EnvironmentObject var sharedData: SharedDataModel
    @State var txt = ""
    
    let layout = [
        GridItem(.fixed(180)),
        GridItem(.fixed(180))
    ]
    
    var body : some View{
        VStack(spacing: 20){
            HStack (spacing: 20) {

                Text("C-Store")
                    .font(.system(size: 40))
                    .foregroundColor(Color.black)

                Spacer()
            }
                
                    VStack(spacing: 15){
                    
                    // Search bar
                        ZStack {
                            if sharedData.searchActivated {
                                SearchBar()
                            } else {
                                SearchBar()
                                    .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                            }
                        }
                        .padding(.horizontal, 25)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                sharedData.searchActivated = true
                            }
                        }
                    
                    
                        HStack{

                            Text("Order online, pick up in store").font(.body)
                            
                            Spacer()
                            
                        }
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                    
                        // Product list
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            LazyVGrid(columns: layout){
                                ForEach(sharedData.products){ product in
                                    // Product Tile View
                                    ProductTileView(product: product)
                                }
                            }
                            .padding(.horizontal, 25)
                        }
                        .padding(0)
                    }
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .overlay(
                        ZStack {
                            if sharedData.searchActivated {
                                SearchView(animation: animation)
                                    .environmentObject(sharedData)
                            }
                        }
                    )
    }
    
    @ViewBuilder
    func SearchBar() -> some View {
        HStack(spacing: 15){
            
            HStack{
                
                Image(systemName: "magnifyingglass").font(.body)
                
                TextField("Enter a product", text: $txt)
                
            }.padding(10)
            .background(Color("powder"))
            .cornerRadius(20)
        }
    }
    
    @ViewBuilder
    func ProductTileView(product: Product) -> some View {
        VStack(spacing: 10) {
            
            AsyncImage(url: URL(string: product.image), content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .matchedGeometryEffect(id: "\(product.id)IMAGE", in: animation)
            }, placeholder: {
                Color.gray
            })
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

struct StorePage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}

