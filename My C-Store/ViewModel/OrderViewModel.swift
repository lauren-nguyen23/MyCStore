import SwiftUI

class OrderViewModel: ObservableObject {
    @Published var orders: [Order] = [
        Order(total: 24.95, date: "Mar 8, 2023", status: "In progress"),
        Order(total: 10.35, date: "Feb 24, 2023", status: "Complete"),
        Order(total: 4.85, date: "Feb 2, 2023", status: "Complete")
    ]
}
