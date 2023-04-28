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
        if let planet = velClass.planetVehicleArray[sectionNo-1].planet {
            bool2 = vel.max_distance < planet.distance
        }
        
        let bool = bool1 || bool2
        return bool
    }
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Spacer()
                ForEach((0...(velocities.count-1)), id: \.self) { indx in
                     
                    RadioButtonField(
                        id: velocities[indx].name,
                        label: velocities[indx].name,
                        totalNo: velocities[indx].total_no,
                        color:.red,
                        bgColor: .black,
                        
                        isMarked: velClass.getVehicleNameValue(sectionNo: sectionNo) == velocities[indx].name ? true : false,
                        callback: { selected in
                            if velClass.getVehicleNameValue(sectionNo: sectionNo) == selected{
                                return
                            }
                            velocities[indx].total_no -= 1
                            var found = true
                            for j in 0...(velocities.count-1){
                                if j != indx{
                                    if velClass.getOldVehicleNameValue(sectionNo: sectionNo) == velocities[j].name{
                                       
                                        velClass.didChangeIn(vel: velocities[indx],  sectionNo: sectionNo)
                                        found = false
                                    }
                                }
                            }
                            if found == true{
                                velClass.didChangeIn(vel: velocities[indx],  sectionNo: sectionNo)
                            }
                           
                            print("Selected Vehicle is: \(selected)")
                        }
                    )
                    .disabled(getOptionButtonVisibility(vel: velocities[indx]) )
                    }
                
               
               Spacer()
            }
           
            
        }
    }
}


