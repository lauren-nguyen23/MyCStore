import SwiftUI
import Parse
import ParseSwift

struct OrdersPage: View {

    @EnvironmentObject var sharedData: SharedDataModel
    
    var body : some View{
            
        VStack {
            HStack {
                Text("Orders")
                    .font(.system(size: 40))
                    .foregroundColor(Color.black)
                
                Spacer()
            }
            .padding(15)
            
            ScrollView(.vertical, showsIndicators: false) {
            // check if there are any past orders at all
                if sharedData.myOrders.isEmpty {
                    Group {
                        Text("Your order history is empty.")
                            .font(.custom(customFont, size: 20))
                            .fontWeight(.semibold)
                    }
                } else {
                    // displaying all orders
                    VStack(spacing: 15) {
                        ForEach(sharedData.myOrders) { order in
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
            
            Text("$" + String(format: "%.2f", order.total))
                .font(.custom(customFont, size: 17))
                .fontWeight(.bold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group{
                if (order.status == "In progress") {
                    Color("in_progress")
                        .cornerRadius(20)
                } else if (order.status == "Complete") {
                    Color("complete")
                        .cornerRadius(20)
                } else if (order.status == "Cancelled") {
                    Color("cancelled")
                        .cornerRadius(20)
                }
            }
        )
    }
}

struct OrdersPage_Previews: PreviewProvider {
    static var previews: some View {
        OrdersPage()
            .environmentObject(SharedDataModel())
    }
}
