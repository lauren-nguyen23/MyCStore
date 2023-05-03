import SwiftUI
import Parse

struct AccountPage: View {
    
    @State var showOnBoardingPage: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Account")
                    .font(.system(size: 40))
                    .foregroundColor(Color.black)
                
                Spacer()
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
            
            Text("Please contact Bon Appetit for support")
            
            Spacer()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct AccountPage_Previews: PreviewProvider {
    static var previews: some View {
        AccountPage()
    }
}
