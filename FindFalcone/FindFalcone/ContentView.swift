//
//  ContentView.swift
//  FindFalcone
//
//  Created by Najran Emarah on 03/10/1444 AH.
//

import SwiftUI

struct SectionView: View {
    @ObservedObject var velocitieClass:ViewModelClass = ViewModelClass()
    @State var sectionNo = 0
    @State var planet: Planet?
    
    var body: some View {
        VStack{
            
            Menu(velocitieClass.getButtonTitle(sectionNo: sectionNo)) {
                ForEach(velocitieClass.planets, id: \.name) { planet in
                    
                    Button(planet.name) {
                      
                        velocitieClass.changeButtonTitle(title: planet.name, sectionNo: sectionNo)
                       
                        self.planet = planet
                        velocitieClass.selectPlanet(planet: planet, sectionNo: sectionNo)
                     
                 }
                    }
                        
                    }
            .buttonStyle(.bordered)
            .foregroundColor(.black)
            RadioButtonView(velClass: self.velocitieClass,planetDistance: planet?.distance ?? 0 ,velocities: $velocitieClass.velocities,sectionNo: sectionNo)
                .opacity(!velocitieClass.getVehicleShowOption(sectionNo: sectionNo) ? 0 : 1)
      
            
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
                   
                    if !velocitieClass.velocities.isEmpty{
                        Text("Select the planets you want to search in")
                            .foregroundColor(.black)
                            .font(.title2)
                            .padding(.vertical)
                        
                        ScrollView(.horizontal){
                            ForEach((1...velocitieClass.totalSection), id: \.self) { indx in
                                if indx % 2 != 0{
                                    HStack(spacing:5){
                                        SectionView(velocitieClass: velocitieClass, sectionNo: indx)
                                            .frame(width: 160)
                                        
                                            .padding()
                                        SectionView(velocitieClass: velocitieClass, sectionNo: indx+1)
                                            .frame(width: 150)
                                            .padding()
                                    }
                                }
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
                    velocitieClass.initPlanetVehicle()
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
