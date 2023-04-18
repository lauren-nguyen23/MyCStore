import SwiftUI

struct MainPage: View {
    
    //Current tab
    @State var currentTab: Tab = .Store
    
    @StateObject var sharedData: SharedDataModel = SharedDataModel()
    
    @Namespace var animation
    
    //Hiding Tab Bar
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            //Tab View
            TabView(selection: $currentTab) {
                StorePage(animation: animation)
                    .environmentObject(sharedData)
                    .tag(Tab.Store)
                
                WishlistPage()
                    .environmentObject(sharedData)
                    .tag(Tab.Wishlist)
                
                OrdersPage()
                    .tag(Tab.Orders)
                
                CartPage()
                    //.environmentObject(sharedData)
                    .tag(Tab.Cart)
            }
            
            //Custom Tab Bar
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    
                    Button {
                        //button action: updating tab
                        currentTab = tab
                    } label: {
                        Image(tab.rawValue)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(currentTab == tab ? Color(.black) : Color("grey"))
                    }
                }
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 10)
        }
        .overlay(
            ZStack {
                //ProductDetailView
                if let product = sharedData.detailProduct, sharedData.showDetailProduct {
                    
                    ProductDetailView(product: product, animation: animation)
                        .environmentObject(sharedData)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                }
            }
        )
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}

//Making Case Iterable
//Tab cases
enum Tab: String, CaseIterable {
    case Store = "Store"
    case Wishlist = "Wishlist"
    case Orders = "Orders"
    case Cart = "Cart"
}

