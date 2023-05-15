import SwiftUI

struct MainPage: View {
    
    // Current tab
    @State var currentTab: Tab = .Store
    
    @StateObject var sharedData: SharedDataModel = SharedDataModel()
    
    @Namespace var animation
    
    // Hiding Tab Bar
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        NavigationView{
        
            VStack(spacing: 0) {
                
                // Tab View
                TabView(selection: $currentTab) {
                    StorePage(animation: animation)
                        .environmentObject(sharedData)
                        .tag(Tab.Store)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    
                    WishlistPage()
                        .environmentObject(sharedData)
                        .tag(Tab.Wishlist)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    
                    OrdersPage()
                        .environmentObject(sharedData)
                        .tag(Tab.Orders)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    
                    CartPage()
                        .environmentObject(sharedData)
                        .tag(Tab.Cart)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    
                    AccountPage()
                        .tag(Tab.Account)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }
                
                // Custom Tab Bar
                HStack(spacing: 0) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        
                        Button {
                            // button action: updating tab
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
                    // ProductDetailView
                    if let product = sharedData.detailProduct, sharedData.showDetailProduct {
                        
                        ProductDetailView(product: product, animation: animation)
                            .environmentObject(sharedData)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                    }
                }
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}

// Tab cases
enum Tab: String, CaseIterable {
    case Store = "Store"
    case Wishlist = "Wishlist"
    case Orders = "Orders"
    case Cart = "Cart"
    case Account = "Account"
}

