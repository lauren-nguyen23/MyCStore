import SwiftUI

struct LoginPage: View {
    @StateObject var loginData: LoginPageModel = LoginPageModel()
    var body: some View {
        VStack {
            //Welcome text
            Text("Welcome to\nMy C-Store!")
                .font(.custom(customFont, size: 30).bold())
                .foregroundColor(.black.opacity(0.75))
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: UIScreen.main.bounds.height/3.5)
                .padding()
            
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    //Login input fields
                    Spacer()
                    CustomTextField(hint: "Enter your email", value: $loginData.email, password: false)
                    Spacer()
                    CustomTextField(hint: "Enter your password", value: $loginData.password, password: true)
                    
                    Spacer()
                    //Signin button
                    Button {
                        loginData.login()
                    } label: {
                        Text("Sign In")
                            .font(.custom(customFont, size: 17).bold())
                            .padding(.vertical, 20)
                            .frame(maxWidth: 170, maxHeight: 45)
                            .foregroundColor(.white)
                            .background(Color("supple"))
                            .cornerRadius(50)
                    }
                    .padding(.top, 25)
                    .padding(.horizontal)
                }
                .padding(30)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("supple"))
    }
    
    @ViewBuilder
    func CustomTextField(hint: String, value: Binding<String>, password: Bool)->some View {
        if (password) {
            SecureField(hint, text: value)
                .padding(.top, 2)
        } else {
            TextField(hint, text: value)
                .padding(.top, 2)
        }
        
        Divider()
            .background(Color("powder"))
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
