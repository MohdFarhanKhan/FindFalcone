//
//  ResultView.swift
//  FalconFind
//
//  Created by Najran Emarah on 25/09/1444 AH.
//

import SwiftUI
struct SuccessView: View {
   
    @ObservedObject var velocitieClass:ViewModelClass = ViewModelClass()
    @Binding var pushed: Bool
   
    var body: some View {
            
            VStack{
                Spacer()
                Text("Success!Congratulation on Finding Falcon. King Shan is mighty pleased ")
                    .foregroundColor(.black)
                    .font(.title)
                Spacer()
                
                Text("Time taken:\(String(format: " %.2f", velocitieClass.timeTaken)) ")
                    .foregroundColor(.black)
                    .font(.title2)
                Text("Planet found:\(velocitieClass.successPlanet?.planetName ?? "")")
                    .foregroundColor(.black)
                    .font(.title2)
                Spacer()
                Button("Start Again") {
                    velocitieClass.resetAll()
                    self.pushed = false
                }
                .buttonStyle(.bordered)
                Spacer()
            }
            .onDisappear(){
                velocitieClass.resetAll()
                self.pushed = false
            }
        
     
    }
}
struct ErrorView: View {
   
    @ObservedObject var velocitieClass:ViewModelClass = ViewModelClass()
    @Binding var pushed: Bool
    var body: some View {
        
            VStack{
                Text("Not success ")
                    .foregroundColor(.black)
                    .font(.title)
                Spacer()
                
                Text("\(velocitieClass.errorString!)")
                    .foregroundColor(.black)
                    .font(.title2)
                Button("Start Again") {
                    velocitieClass.resetAll()
                    self.pushed = false
                }
                .buttonStyle(.bordered)
                
            }
            .onDisappear(){
                velocitieClass.resetAll()
                self.pushed = false
            }
     
    }
}
struct ResultView: View {
    @Binding var pushed: Bool
    @ObservedObject var velocitieClass:ViewModelClass = ViewModelClass()
    @State var grediant = Gradient(colors: [.yellow, .white,  . yellow, .white])
    
    var body: some View {
        NavigationView{
            ZStack{
                AngularGradient(gradient: grediant , center: .center)
                    .ignoresSafeArea()
                    .blur(radius: 200,opaque: true)
                    .opacity(0.8)
                VStack{
                    Text(" Finding Falcon! ")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                    if velocitieClass.successPlanet != nil{
                        Spacer()
                        SuccessView(velocitieClass: velocitieClass, pushed: $pushed)
                    }
                    else{
                        ErrorView(velocitieClass: velocitieClass, pushed: $pushed)
                    }
                    
                }
                .onDisappear(){
                    velocitieClass.resetAll()
                    self.pushed = false
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        @State var  isPushed = false
        ResultView(pushed: $isPushed)
    }
}
