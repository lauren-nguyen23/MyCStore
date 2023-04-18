import SwiftUI

struct OrdersPage: View {
    
    //@EnvironmentObject
    @StateObject var orderData: OrderViewModel = OrderViewModel()
    
    var body : some View{
        
        NavigationView {
            
                VStack {
                    HStack {
                        Text("Orders")
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
                    //check if there are any past orders at all
                    if orderData.orders.isEmpty {
                        Group {
                            Text("Your wishlist is empty")
                                .font(.custom(customFont, size: 20))
                                .fontWeight(.semibold)
                        }
                    } else {
                        //displaying all fav products
                        VStack(spacing: 15) {
                            //TODO: replace storeData with sharedData
                            ForEach(orderData.orders) { order in
                                HStack (spacing: 0) {
                                    OrderCardView(order: order)
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
    func OrderCardView(order: Order) -> some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 8) {
                Text(order.date)
                    .font(.custom(customFont, size: 18).bold())
                    .lineLimit(1)
                
                Text(order.status)
                    .font(.custom(customFont, size: 17))
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Text(order.total)
                .font(.custom(customFont, size: 17))
                .fontWeight(.bold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color("tile_bg")
                .cornerRadius(20)
        )
    }
    
    //TODO: write delete function
    func deleteProduct(product: Product) {
        
    }
}

struct OrdersPage_Previews: PreviewProvider {
    static var previews: some View {
        OrdersPage()
            //.environmentObject(SharedDataModel())
    }
}
