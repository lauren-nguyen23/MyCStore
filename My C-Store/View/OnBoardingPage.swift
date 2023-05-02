import SwiftUI

let customFont = "Poppins-Light"

struct OnBoardingPage: View {
    //Navigate to Login page
    @State var showLoginPage: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("logo_launch")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("Make the C-Store convenient again.")
                .font(.custom(customFont, size: 15))
                .fontWeight(.regular)
                .foregroundColor(.black.opacity(0.75))
            
            Button {
                withAnimation {
                    showLoginPage = true
                }
            } label: {
                Text("Get started")
                    .font(.custom(customFont, size: 18))
                    .fontWeight(.semibold)
                    .padding(.vertical, 18)
                    .frame(maxWidth: 170, maxHeight: 45)
                    .background(Color("supple"))
                    .cornerRadius(50)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal, 30)
            .offset(y: 130)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .overlay(
            Group {
                if showLoginPage{
                    LoginPage()
                        .transition(.move(edge: .bottom))
                }
            }
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct OnBoardingPage_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingPage()
            .previewDevice("iPhone 13 Pro")
    }
}
