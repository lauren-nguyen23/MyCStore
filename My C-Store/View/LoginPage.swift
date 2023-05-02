import SwiftUI

struct LoginPage: View {
    @StateObject var loginData: LoginPageModel = LoginPageModel()
    
    @State var showMainPage: Bool = false
    
    var body: some View {
        NavigationView{
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
                        CustomTextField(hint: "Enter your username", value: $loginData.username, password: false)
                        Spacer()
                        CustomTextField(hint: "Enter your password", value: $loginData.password, password: true)
                        
                        Spacer()
                        
                        NavigationLink(
                            destination:
                                MainPage()
                                    .navigationBarTitle("")
                                        .navigationBarHidden(true)
                                            .navigationBarBackButtonHidden(true),
                            isActive: $showMainPage) {
                                EmptyView()
                            }
                        //Signin button
                        Button {
                            loginData.login()
                            if (loginData.loginStatus) {
                                self.showMainPage = true
                            } else {
                                self.showMainPage = false
                            }
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
