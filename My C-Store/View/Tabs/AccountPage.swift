import SwiftUI
import Parse

struct AccountPage: View {
    
    @AppStorage("loginStatus") var loginStatus: Bool = false
    
    @State var showOnBoardingPage: Bool = false
    @State var showHelp: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Account")
                    .font(.system(size: 40))
                    .foregroundColor(Color.black)
                
                Spacer()
                
                // Help button
                Button {
                    withAnimation{
                        showHelp.toggle()
                    }
                } label: {
                    Image(systemName: "questionmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color("supple"))
                }
                .popover(isPresented: $showHelp) {
                    HelpPopover()
                }
            }
            .padding(15)
                
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15){
                    if let imageFile = PFUser.current()!["avatar"] as! PFFileObject {
                        let urlString = imageFile.url!
                        let url = URL(string: urlString)!
                        
                        AsyncImage(
                          url: url,
                          content: { image in
                          image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        }, placeholder: {
                          Color.gray
                        })
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .clipShape(Circle())
                        .padding(40)
                    }
                        
                    
                    if let name = PFUser.current()!["name"] as? String {
                        Text(name)
                            .font(.custom(customFont, size: 35))
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                    }
                    
                    Text(PFUser.current()?.email ?? "")
                        .font(.custom(customFont, size: 20))
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .frame(maxWidth: 350, alignment: .center)
                        .background(
                            Color("off_white")
                                .cornerRadius(50)
                        )
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .frame(maxWidth: 400, maxHeight: 500)
            .background(
                Color("powder")
                    .ignoresSafeArea()
                    .cornerRadius(25)
            )
            
            Spacer()
            
            NavigationLink(
                destination:
                    OnBoardingPage()
                    .navigationBarTitle("")
                    .navigationBarHidden(true),
                isActive: $showOnBoardingPage) {
                    EmptyView()
                }
            Button {
                PFUser.logOut()
                loginStatus = false
                self.showOnBoardingPage = true
                print("User logged out")
            } label: {
                Text("Sign Out")
                    .font(.custom(customFont, size: 17).bold())
                    .padding(.vertical, 20)
                    .frame(maxWidth: 170, maxHeight: 45)
                    .foregroundColor(.white)
                    .background(Color("supple"))
                    .cornerRadius(50)
            }
            .padding(.top, 25)
            .padding(.horizontal)
            
            Spacer()
            
            Text("Please click on the question mark at the top right corner for support")
                .padding(.horizontal)
                .padding(.top, 10)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    func HelpPopover() -> some View {
        VStack {
            HStack (alignment: .top, spacing: 10) {
            
                Text("Need help?")
                    .font(.custom(customFont, size: 30).bold())
                    .fontWeight(.bold)
                    .padding([.top, .leading])
            
                Spacer ()
            
                // button to close popover
                Button (action: {
                   showHelp.toggle()
                }, label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color("supple"))
                })
                .padding([.top, .trailing])
    
            }
            .padding(.vertical, 10)
            
            Spacer()
            
            VStack{
                Text("Get in touch with Bon Appetit:")
                    .font(.custom(customFont, size: 20).bold())
                    .fontWeight(.bold)
                    .padding([.top, .leading])
                    .padding(.bottom, 50)
            
                Link("Call", destination: URL(string: "tel:7656584322")!)
                    .font(.custom(customFont, size: 17).bold())
                    .padding(.vertical, 20)
                    .frame(maxWidth: 250, maxHeight: 45)
                    .foregroundColor(.white)
                    .background(Color("supple"))
                    .cornerRadius(50)
                
                Button(action: {
                    let phoneNumber = "messages://7656584322"
                    guard let url = URL(string: phoneNumber) else { return }
                    UIApplication.shared.open(url)
                }) {
                   Text("Send a text message")
                        .font(.custom(customFont, size: 17).bold())
                        .padding(.vertical, 20)
                        .frame(maxWidth: 250, maxHeight: 45)
                        .foregroundColor(.white)
                        .background(Color("supple"))
                        .cornerRadius(50)
                }

                Link("Send an email", destination: URL(string: "mailto:johnhecko@depauw.edu")!)
                    .font(.custom(customFont, size: 17).bold())
                    .padding(.vertical, 20)
                    .frame(maxWidth: 250, maxHeight: 45)
                    .foregroundColor(.white)
                    .background(Color("supple"))
                    .cornerRadius(50)
                    
                Link("Visit their website", destination: URL(string: "https://depauw.cafebonappetit.com")!)
                    .font(.custom(customFont, size: 17).bold())
                    .padding(.vertical, 20)
                    .frame(maxWidth: 250, maxHeight: 45)
                    .foregroundColor(.white)
                    .background(Color("supple"))
                    .cornerRadius(50)
                
            }
            Spacer()
        }
    }
}

struct AccountPage_Previews: PreviewProvider {
    static var previews: some View {
        AccountPage()
    }
}
