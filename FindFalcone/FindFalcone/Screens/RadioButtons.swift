//
//  RadioButtons.swift
//  FalconFind
//
//  Created by Najran Emarah on 16/09/1444 AH.
//

import SwiftUI

struct RadioButtonField: View {
    let id: String
    let label: String
    let total_No: Int
    let size: CGFloat
    let color: Color
    let bgColor: Color
    let textSize: CGFloat
    let isMarked:Bool
    
    let callback: (String)->()
    
    init(
        id: String,
        label:String,
        totalNo:Int,
        size: CGFloat = 20,
        color: Color = Color.black,
        bgColor: Color = Color.black,
        textSize: CGFloat = 14,
        isMarked: Bool = false,
        callback: @escaping (String)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.bgColor = bgColor
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
        self.total_No = totalNo
    }
    
    var body: some View {
        Button(action:{
            self.callback(self.id)
        }) {
            
            HStack {
                Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                    
                    .foregroundColor(self.bgColor)
                    
                Text("\(label)(\(total_No))")
                    .font(Font.system(size: textSize))
            }
            
        }
        
    }
}
struct RadioButtonView: View {
    @State var  velClass: ViewModelClass
    @State var planetDistance = 0
    @Binding var velocities :[Velocity]
    @State var sectionNo :Int
    
    func getOptionButtonVisibility(vel:Velocity)->Bool{
        
        let bool1 = velClass.getVehicleNameValue(sectionNo: sectionNo) != vel.name && vel.total_no <= 0
        var bool2 = false
        if sectionNo == 1{
            if let planet = velClass.selectedPlanet1 {
                bool2 = vel.max_distance < planet.distance
            }
        }
        if sectionNo == 2{
            if let planet = velClass.selectedPlanet2 {
                bool2 = vel.max_distance < planet.distance
            }
        }
        if sectionNo == 3{
            if let planet = velClass.selectedPlanet3 {
                bool2 = vel.max_distance < planet.distance
            }
        }
        if sectionNo == 4{
            if let planet = velClass.selectedPlanet4 {
                bool2 = vel.max_distance < planet.distance
            }
        }
        let bool = bool1 || bool2
        return bool
    }
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                
                        RadioButtonField(
                            id: velocities[0].name,
                            label: velocities[0].name,
                            totalNo: velocities[0].total_no,
                            color:.red,
                            bgColor: .black,
                            
                            isMarked: velClass.getVehicleNameValue(sectionNo: sectionNo) == velocities[0].name ? true : false,
                            callback: { selected in
                                if velClass.getVehicleNameValue(sectionNo: sectionNo) == selected{
                                    return
                                }
                                velClass.setVehicleNameValue(sectionNo: sectionNo, value: selected)
                               velocities[0].total_no -= 1
                                if velClass.getOldVehicleNameValue(sectionNo: sectionNo) == velocities[1].name{
                                    velClass.didChangeIn(vel: velocities[0], oldVel: velocities[1], sectionNo: sectionNo)
                                }
                                else if velClass.getOldVehicleNameValue(sectionNo: sectionNo) == velocities[2].name{
                                    velClass.didChangeIn(vel: velocities[0], oldVel: velocities[2], sectionNo: sectionNo)
                                }
                                else if velClass.getOldVehicleNameValue(sectionNo: sectionNo) == velocities[3].name{
                                    velClass.didChangeIn(vel: velocities[0], oldVel: velocities[3], sectionNo: sectionNo)
                                }
                                else{
                                    velClass.didChangeIn(vel: velocities[0], oldVel: nil, sectionNo: sectionNo)
                                }
                                velClass.setOldVehicleNameValue(sectionNo: sectionNo, value: velClass.getVehicleNameValue(sectionNo: sectionNo))
                               
                                print("Selected Gender is: \(selected)")
                            }
                        )
                        
                        .disabled(getOptionButtonVisibility(vel: velocities[0]) )
                
                        
                RadioButtonField(
                    id: velocities[1].name,
                    label: velocities[1].name,
                    totalNo: velocities[1].total_no,
                    color:.red,
                    bgColor: .black,
                    isMarked: velClass.getVehicleNameValue(sectionNo: sectionNo) == velocities[1].name ? true : false,
                    callback: { selected in
                        if velClass.getVehicleNameValue(sectionNo: sectionNo) == selected{
                            return
                        }
                        velClass.setVehicleNameValue(sectionNo: sectionNo, value: selected)
                      
                        velocities[1].total_no -= 1
                        if velClass.getOldVehicleNameValue(sectionNo: sectionNo) == velocities[0].name{
                            velClass.didChangeIn(vel: velocities[1], oldVel: velocities[0], sectionNo: sectionNo)
                        }
                        else if velClass.getOldVehicleNameValue(sectionNo: sectionNo) == velocities[2].name{
                            velClass.didChangeIn(vel: velocities[1], oldVel: velocities[2], sectionNo: sectionNo)
                        }
                        else if velClass.getOldVehicleNameValue(sectionNo: sectionNo) == velocities[3].name{
                            velClass.didChangeIn(vel: velocities[1], oldVel: velocities[3], sectionNo: sectionNo)
                        }
                        else{
                            velClass.didChangeIn(vel: velocities[1], oldVel: nil, sectionNo: sectionNo)
                        }
                        velClass.setOldVehicleNameValue(sectionNo: sectionNo, value: velClass.getVehicleNameValue(sectionNo: sectionNo))
                       
                       
                       
                        print("Selected Gender is: \(selected)")
                    }
                )
                .disabled(getOptionButtonVisibility(vel: velocities[1]))
                RadioButtonField(
                    id: velocities[2].name,
                    label: velocities[2].name,
                    totalNo: velocities[2].total_no,
                    color:.red,
                    bgColor: .black,
                    isMarked: velClass.getVehicleNameValue(sectionNo: sectionNo) == velocities[2].name ? true : false,
                    callback: { selected in
                        if velClass.getVehicleNameValue(sectionNo: sectionNo) == selected{
                            return
                        }
                        velClass.setVehicleNameValue(sectionNo: sectionNo, value: selected)
                       
                        velocities[2].total_no -= 1
                        if velClass.getOldVehicleNameValue(sectionNo: sectionNo) == velocities[0].name{
                            velClass.didChangeIn(vel: velocities[2], oldVel: velocities[0], sectionNo: sectionNo)
                        }
                        else if velClass.getOldVehicleNameValue(sectionNo: sectionNo) == velocities[1].name{
                            velClass.didChangeIn(vel: velocities[2], oldVel: velocities[1], sectionNo: sectionNo)
                        }
                        else if velClass.getOldVehicleNameValue(sectionNo: sectionNo) == velocities[3].name{
                            velClass.didChangeIn(vel: velocities[2], oldVel: velocities[3], sectionNo: sectionNo)
                        }
                        else{
                            velClass.didChangeIn(vel: velocities[2], oldVel: nil, sectionNo: sectionNo)
                        }
                        
                        velClass.setOldVehicleNameValue(sectionNo: sectionNo, value: velClass.getVehicleNameValue(sectionNo: sectionNo))
                       
                       
                        print("Selected Gender is: \(selected)")
                    }
                )
                .disabled(getOptionButtonVisibility(vel: velocities[2]))
        RadioButtonField(
            id: velocities[3].name,
            label: velocities[3].name,
            totalNo: velocities[3].total_no,
            color:.red,
            bgColor: .black,
            isMarked: velClass.getVehicleNameValue(sectionNo: sectionNo) == velocities[3].name ? true : false,
            callback: { selected in
                if velClass.getVehicleNameValue(sectionNo: sectionNo) == selected{
                    return
                }
                velClass.setVehicleNameValue(sectionNo: sectionNo, value: selected)
               
                velocities[3].total_no -= 1
                if velClass.getOldVehicleNameValue(sectionNo: sectionNo) == velocities[0].name{
                    velClass.didChangeIn(vel: velocities[3], oldVel: velocities[0], sectionNo: sectionNo)
                }
                else if velClass.getOldVehicleNameValue(sectionNo: sectionNo) == velocities[1].name{
                    velClass.didChangeIn(vel: velocities[3], oldVel: velocities[1], sectionNo: sectionNo)
                }
                else if velClass.getOldVehicleNameValue(sectionNo: sectionNo) == velocities[2].name{
                    velClass.didChangeIn(vel: velocities[3], oldVel: velocities[2], sectionNo: sectionNo)
                }
                else{
                    velClass.didChangeIn(vel: velocities[3], oldVel: nil, sectionNo: sectionNo)
                }
                velClass.setOldVehicleNameValue(sectionNo: sectionNo, value: velClass.getVehicleNameValue(sectionNo: sectionNo))
               
                print("Selected Gender is: \(selected)")
            }
        )
        
        .disabled(getOptionButtonVisibility(vel: velocities[3]))
               
               Spacer()
            }
           
            
        }
    }
}


