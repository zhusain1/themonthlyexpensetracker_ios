//
//  ContentView.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/3/22.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var userRequestViewModel : AuthenticationViewModel
    
    @State var errorMessage = "Invalid Login. Please try again"
    
    var body: some View {
        ZStack{
            Color.bg
                .ignoresSafeArea()
            VStack(
                spacing: -20
            ){
                Branding()
                VStack{
                    if userRequestViewModel.loginError{
                        HStack{
                            Image(systemName: "exclamationmark.circle.fill")
                            Text(errorMessage)
                                .fontWeight(.bold)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(Color.white)
                    }
                    Fields().environmentObject(userRequestViewModel)
                    Button("Login", action:{
                        Task{
                            await userRequestViewModel.loginSubmit()
                        }
                        
                        if userRequestViewModel.loginError{
                            errorMessage = "Invalid Login. Please try again"
                        }
                    })
                    .padding()
                    .frame(width: 300)
                    .background(
                        changeButtonColor()
                    )
                    .font(.title3.bold())
                    .cornerRadius(25)
                    .foregroundColor(Color.white)
                    .disabled(validateButton())
                    Button(
                        action:{
                            userRequestViewModel.loginBiometric() { (result:Result<Bool,BioError>) in
                                switch result {
                                case .success:
                                    Task{
                                        await userRequestViewModel.loginSubmit()
                                    }
                                case .failure:
                                    errorMessage = "Face ID unavailable"
                                }
                            }
                            
                        },
                        label:{
                            if(!biometricType().isEmpty){
                                VStack{
                                    Image(systemName: biometricType())
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                            }
                        }
                    )
                    .padding()
                    Spacer()
                }
            }
            .padding()
            .background(Color.white)
            .frame(height: 580)
            .clipped()
            .shadow(color: Color.black, radius: 2, x: 0.6, y: 1)
            .offset(y: -60)
        }
    }
    
    func changeButtonColor() -> Color{
        if !userRequestViewModel.userRequest.email.isEmpty && !userRequestViewModel.userRequest.password.isEmpty{
            return Color.black
        } else{
            return Color.gray
        }
    }
    
    
    func validateButton() -> Bool{
        if !userRequestViewModel.userRequest.email.isEmpty && !userRequestViewModel.userRequest.password.isEmpty{
            return false
        } else{
            return true
        }
    }
}
    
struct Fields: View{
    
    @EnvironmentObject var userRequestViewModel : AuthenticationViewModel
    
    var body: some View{
        VStack(alignment: .leading){
            Text("Email")
                .fontWeight(.bold)
            TextField(
                "Email",
                text: $userRequestViewModel.userRequest.email
            )
            .autocapitalization(.none)
            .padding()
            .frame(maxWidth: 350)
            .border(loginError())
            .padding(.bottom)
            
            Text("Password")
                .fontWeight(.bold)
            SecureField(
                "Password",
                text: $userRequestViewModel.userRequest.password
            )
            .padding()
            .frame(maxWidth: 350)
            .border(loginError())
            .padding(.bottom)
        }
    }
    
    func loginError() -> Color{
        if userRequestViewModel.loginError{
            return Color.red
        } else{
            return Color.black
        }
    }
}
    
struct Branding: View{
    var body: some View{
        HStack{
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 200, alignment: .leading)
            Text("The Monthly Expense Tracker")
                .bold()
                .font(.title3)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    
    static let vm = AuthenticationViewModel()
    
    static var previews: some View {
        
        LoginView().environmentObject(vm)
    }
}
