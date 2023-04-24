//
//  ContentView.swift
//  FindFalcone
//
//  Created by Najran Emarah on 03/10/1444 AH.
//

import SwiftUI
struct Section1View: View {
    @ObservedObject var velocitieClass:ViewModelClass = ViewModelClass()
    @State var planet: Planet?
    
    var body: some View {
        VStack{
            
            Menu(velocitieClass.buttonTitle1) {
                ForEach(velocitieClass.planets, id: \.name) { planet in
                    
                    Button(planet.name) {
                      
                        velocitieClass.changeButtonTitle(title: planet.name, sectionNo: 1)
                       
                        self.planet = planet
                        velocitieClass.selectPlanet(planet: planet, sectionNo: 1)
                     
                        velocitieClass.setVehicleNameValue(sectionNo: 1, value: "")
                        velocitieClass.setOldVehicleNameValue(sectionNo: 1, value: "")
                    }
                    }
                        
                    }
            .buttonStyle(.bordered)
            .foregroundColor(.black)
            RadioButtonView(velClass: self.velocitieClass,planetDistance: planet?.distance ?? 0 ,velocities: $velocitieClass.velocities1,sectionNo: 1)
                .opacity(!velocitieClass.isVelocityOptionShow1 ? 0 : 1)
                
           
           
            
        }
        .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 2)
                )
        
       
       
    }
    
}
struct Section2View: View {
    @ObservedObject var velocitieClass:ViewModelClass = ViewModelClass()
    @State var planet: Planet?
    
    var body: some View {
        VStack{
            
            Menu(velocitieClass.buttonTitle2) {
                ForEach(velocitieClass.planets, id: \.name) { planet in
                    
                    Button(planet.name) {
                       
                        velocitieClass.changeButtonTitle(title: planet.name, sectionNo: 2)
                       
                        self.planet = planet
                        velocitieClass.selectPlanet(planet: planet, sectionNo: 2)
                        velocitieClass.setVehicleNameValue(sectionNo: 2, value: "")
                        velocitieClass.setOldVehicleNameValue(sectionNo: 2, value: "")
                       
                    }
                    }
                        
                    }
            .buttonStyle(.bordered)
            .foregroundColor(.black)
            RadioButtonView(velClass: self.velocitieClass,planetDistance: planet?.distance ?? 0 ,velocities: $velocitieClass.velocities1,sectionNo: 2)
                .opacity(!velocitieClass.isVelocityOptionShow2 ? 0 : 1)
           
           
            
        }
        .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 2)
                )
       
    }
}
struct Section3View: View {
    @ObservedObject var velocitieClass:ViewModelClass = ViewModelClass()
    @State var planet: Planet?
    
    var body: some View {
        VStack{
            
            Menu(velocitieClass.buttonTitle3) {
                ForEach(velocitieClass.planets, id: \.name) { planet in
                    
                    Button(planet.name) {
                      
                        velocitieClass.changeButtonTitle(title: planet.name, sectionNo: 3)
                       
                        self.planet = planet
                        velocitieClass.selectPlanet(planet: planet, sectionNo: 3)
                        velocitieClass.setVehicleNameValue(sectionNo: 3, value: "")
                        velocitieClass.setOldVehicleNameValue(sectionNo: 3, value: "")
                       
                    }
                    }
                        
                    }
            .buttonStyle(.bordered)
            .foregroundColor(.black)
            RadioButtonView(velClass: self.velocitieClass,planetDistance: planet?.distance ?? 0 ,velocities: $velocitieClass.velocities1,sectionNo: 3)
                .opacity(!velocitieClass.isVelocityOptionShow3 ? 0 : 1)
           
           
            
        }
        .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 2)
                )
    }
}
struct Section4View: View {
    @ObservedObject var velocitieClass:ViewModelClass = ViewModelClass()
    @State var planet: Planet?
    
    var body: some View {
        VStack(spacing:10){
            
            Menu(velocitieClass.buttonTitle4) {
                ForEach(velocitieClass.planets, id: \.name) { planet in
                    
                    Button(planet.name) {
                       
                        velocitieClass.changeButtonTitle(title: planet.name, sectionNo: 4)
                       
                        self.planet = planet
                        velocitieClass.selectPlanet(planet: planet, sectionNo: 4)
                        velocitieClass.setVehicleNameValue(sectionNo: 4, value: "")
                        velocitieClass.setOldVehicleNameValue(sectionNo: 4, value: "")
                       
                        
                    }
                    .foregroundColor(.black)
                    
                    }
                        
                    }
            .buttonStyle(.bordered)
            .foregroundColor(.black)
            RadioButtonView(velClass: self.velocitieClass,planetDistance: planet?.distance ?? 0 ,velocities: $velocitieClass.velocities1,sectionNo: 4)
                .opacity(!velocitieClass.isVelocityOptionShow4 ? 0 : 1)
            Spacer()
        }
        .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 2)
                )
        
    }
}
struct StatusView: View {
    @ObservedObject var velocitieClass:ViewModelClass = ViewModelClass()
    @State var pushed: Bool = false
    var body: some View {
        
            VStack{
                NavigationLink(destination:ResultView(pushed: self.$pushed,velocitieClass: velocitieClass), isActive: self.$pushed) { EmptyView() }
                
                Text("Time Taken")
                Spacer()
                Text(String(velocitieClass.timeTaken))
                Spacer()
                HStack{
                    Button("FIND FALCONE") {
                        Task{
                            do {
                                await velocitieClass.findFalcone()
                                pushed = true
                                
                            } catch let serviceError {
                                print( serviceError)
                                pushed = true
                                
                            }
                        }
                    }.buttonStyle(.bordered)
                    .disabled(!velocitieClass.isFindFalconEnable)
                    Button("Reset") {
                        velocitieClass.resetAll()
                    }
                    .buttonStyle(.bordered)
                    
                }
                Spacer()
            }
            .frame(width: 250, height: 100)
            .background(.white)
            
            .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 2)
                    )
            
        
    }
}
struct ContentView: View {
    
    @ObservedObject var velocitieClass:ViewModelClass = ViewModelClass()
    
    @State var grediant = Gradient(colors: [.yellow, .white,  . yellow, .white])
    
    @State var isLoading = false
    
    var body: some View {
        NavigationView{
            ZStack{
                AngularGradient(gradient: grediant , center: .center)
                    .ignoresSafeArea()
                    .blur(radius: 200,opaque: true)
                
                
                VStack{
                    
                    Text(" Finding Falcon! ")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                   
                    if !velocitieClass.velocities1.isEmpty{
                        Text("Select the planets you want to search in")
                            .foregroundColor(.black)
                            .font(.title2)
                            .padding(.vertical)
                        
                        ScrollView(.horizontal){
                            HStack(spacing:5){
                                Section1View(velocitieClass: velocitieClass)
                                    .frame(width: 150)
                                
                                    .padding()
                                Section2View(velocitieClass: velocitieClass)
                                    .frame(width: 150)
                                    .padding()
                            }
                            HStack(spacing:5){
                                Section3View(velocitieClass: velocitieClass)
                                    .frame(width: 150)
                                    .padding()
                                Section4View(velocitieClass: velocitieClass)
                                    .frame(width: 150)
                                    .padding()
                            }
                        }
                        .frame(height: 350)
                        
                        Spacer()
                        
                        StatusView(velocitieClass: velocitieClass)
                        
                        Spacer()
                    }
                    else{
                        Circle()
                            .trim(from: 0, to:0.37)
                            .stroke(Color.red, lineWidth:15)
                            .frame(width:100, height: 100, alignment: .center)
                            .rotationEffect(Angle(degrees: isLoading ? 0 : 360))
                        
                        Text("Fetching data...")
                            .foregroundColor(.red)
                            .onAppear(){
                                withAnimation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false)){
                                    isLoading.toggle()
                                }
                            }
                            
                    }
                    
                    
                }
                .onAppear(){
                    Task{
                        do {
                            isLoading = true
                            
                           await velocitieClass.getDataFromAPI()
                            
                            isLoading = false
                            
                        } catch let serviceError {
                            
                            print( serviceError)
                            
                            isLoading = false
                        }
                    }
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
