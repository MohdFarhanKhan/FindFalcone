//
//  ViewModel.swift
//  FalconFind
//
//  Created by Najran Emarah on 03/10/1444 AH.
//

import Foundation

class  ViewModelClass:ObservableObject{
    var authToken : AuthToken?
    @Published var successPlanet:SuccessPlanet?
    @Published var errorString: String?
    @Published var error: httpError?
    @Published var selectedPlanet1 :Planet?
    @Published var selectedPlanet2 :Planet?
    @Published var selectedPlanet3 :Planet?
    @Published var selectedPlanet4 :Planet?
    @Published var selectedVelocity1 :Velocity?
    @Published var selectedVelocity2 :Velocity?
    @Published var selectedVelocity3 :Velocity?
    @Published var selectedVelocity4 :Velocity?
    @Published var timeTaken :Double = 0
    
    @Published var vehicleName1 = ""
    @Published var OldvehicleName1 = ""
    @Published var vehicleName2 = ""
    @Published var OldvehicleName2 = ""
    @Published var vehicleName3 = ""
    @Published var OldvehicleName3 = ""
    @Published var vehicleName4 = ""
    @Published var OldvehicleName4 = ""
    
    @Published var  buttonTitle1 = "Select Planet"
    @Published var  buttonTitle2 = "Select Planet"
    @Published var  buttonTitle3 = "Select Planet"
    @Published var  buttonTitle4 = "Select Planet"
    @Published var isVelocityOptionShow1 = false
    @Published var isVelocityOptionShow2 = false
    @Published var isVelocityOptionShow3 = false
    @Published var isVelocityOptionShow4 = false
    @Published var isFindFalconEnable = false
  
    @Published  var velocities1:[Velocity] = []
    @Published var velocities2:[Velocity] = []
    @Published var velocities3:[Velocity] = []
    @Published var velocities4:[Velocity] = []
    @Published var planets :[Planet] = []
    var selectedPlanets : [Planet] = []
    
    func mockValues(){
       velocities1 = [Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2),Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4),Velocity(name:"Space shuttle",total_no:1,max_distance:400,speed:5),Velocity(name:"Space ship",total_no:2,max_distance:600,speed:10)]
      velocities2 = [Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2),Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4),Velocity(name:"Space shuttle",total_no:1,max_distance:400,speed:5),Velocity(name:"Space ship",total_no:2,max_distance:600,speed:10)]
       velocities3 = [Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2),Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4),Velocity(name:"Space shuttle",total_no:1,max_distance:400,speed:5),Velocity(name:"Space ship",total_no:2,max_distance:600,speed:10)]
        velocities4 = [Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2),Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4),Velocity(name:"Space shuttle",total_no:1,max_distance:400,speed:5),Velocity(name:"Space ship",total_no:2,max_distance:600,speed:10)]
        planets = [Planet(name:"Donlon",distance:100),Planet(name:"Enchai",distance:200),Planet(name:"Jebing",distance:300),Planet(name:"Sapir",distance:400),Planet(name:"Lerbin",distance:500),Planet(name:"Pingasor",distance:600)]
    }
    
    func findFalcone() async{
       

        var json: [String: Any] = ["token": authToken!.token,
                                   "planet_names": [selectedPlanet1?.name,selectedPlanet2?.name, selectedPlanet3?.name,selectedPlanet4?.name],
                                   "vehicle_names": [selectedVelocity1?.name,selectedVelocity2?.name, selectedVelocity3?.name,selectedVelocity4?.name]]
      
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String
       
        
        // create post request
        let url = Service.findFalconeURL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
       
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
       
        request.httpBody = jsonString.data(using: .utf8)
      
        do{
            let plnt = try await HttpUtility.shared.performOperation(request: request, response: SuccessPlanet.self)
            await MainActor.run {
                self.successPlanet = plnt
                }
             
        }
        catch{
            DispatchQueue.main.async {
                self.error = error as? httpError
                self.errorString = HttpUtility.shared.errorString
               
            }
        }
        
    }
  
    func getToken() async{
        
             var urlRequest = URLRequest(url:  Service.tokenURL)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.httpMethod = "POST"
             let postString = ""
             urlRequest.httpBody = postString.data(using: .utf8)

        do {
            
            authToken =  try await HttpUtility.shared.performOperation(request: urlRequest, response: AuthToken.self)
        } catch  {
            print( error)
        }
    }
    func getPlanets() async{
        var urlRequest = URLRequest(url: Service.planetURL)
        urlRequest.httpMethod = "get"

        do {
            let pnts = try await HttpUtility.shared.performOperation(request: urlRequest, response: [Planet].self)
            DispatchQueue.main.async {
                self.planets = pnts
            }
           
        } catch  {
            print( error)
        }
    }
    
    func getVelocities() async{
        var urlRequest = URLRequest(url: Service.vehiclesURL)
        urlRequest.httpMethod = "get"

        do {
            let vels = try await HttpUtility.shared.performOperation(request: urlRequest, response: [Velocity].self)
            DispatchQueue.main.async {
                self.velocities1 = vels
                self.velocities2 = self.velocities1
                self.velocities3 = self.velocities2
                self.velocities4 = self.velocities3
            }
           
        } catch  {
            print( error)
        }
    }
    
    func getDataFromAPI() async{
        
        await getPlanets()
        await getVelocities()
        await getToken()

    }
    
    func resetAll(){
        successPlanet = nil
        errorString = ""
       error = nil
        selectedPlanet1 = nil
        selectedPlanet2 = nil
        selectedPlanet3 = nil
        selectedPlanet4 = nil
        
        selectedVelocity1 = nil
        selectedVelocity2 = nil
        selectedVelocity3 = nil
        selectedVelocity4 = nil
        
        velocities1 = [Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2),Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4),Velocity(name:"Space shuttle",total_no:1,max_distance:400,speed:5),Velocity(name:"Space ship",total_no:2,max_distance:600,speed:10)]
        velocities2 = [Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2),Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4),Velocity(name:"Space shuttle",total_no:1,max_distance:400,speed:5),Velocity(name:"Space ship",total_no:2,max_distance:600,speed:10)]
        velocities3 = [Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2),Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4),Velocity(name:"Space shuttle",total_no:1,max_distance:400,speed:5),Velocity(name:"Space ship",total_no:2,max_distance:600,speed:10)]
        velocities4 = [Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2),Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4),Velocity(name:"Space shuttle",total_no:1,max_distance:400,speed:5),Velocity(name:"Space ship",total_no:2,max_distance:600,speed:10)]
        planets = [Planet(name:"Donlon",distance:100),Planet(name:"Enchai",distance:200),Planet(name:"Jebing",distance:300),Planet(name:"Sapir",distance:400),Planet(name:"Lerbin",distance:500),Planet(name:"Pingasor",distance:600)]
        selectedPlanets.removeAll()
        
        timeTaken  = 0
        
        vehicleName1 = ""
        OldvehicleName1 = ""
        vehicleName2 = ""
        OldvehicleName2 = ""
        vehicleName3 = ""
        OldvehicleName3 = ""
        vehicleName4 = ""
        OldvehicleName4 = ""
        
        buttonTitle1 = "Select Planet"
        buttonTitle2 = "Select Planet"
        buttonTitle3 = "Select Planet"
        buttonTitle4 = "Select Planet"
        
        isVelocityOptionShow1 = false
        isVelocityOptionShow2 = false
        isVelocityOptionShow3 = false
        isVelocityOptionShow4 = false
        
        isFindFalconEnable = false
    }
    func enableFindFalconButton(){
        if selectedPlanet1 != nil && selectedPlanet2 != nil && selectedPlanet3 != nil &&  selectedPlanet4 != nil && selectedVelocity1 != nil &&  selectedVelocity2 != nil && selectedVelocity3 != nil &&  selectedVelocity4 != nil{
            isFindFalconEnable = true
        }
        else{
            isFindFalconEnable = false
        }
    }
    func changeButtonTitle(title:String, sectionNo:Int){
        if sectionNo == 1{
            buttonTitle1 = title
            isVelocityOptionShow1 = true
        }
        if sectionNo == 2{
            buttonTitle2 = title
            isVelocityOptionShow2 = true
        }
        if sectionNo == 3{
            buttonTitle3 = title
            isVelocityOptionShow3 = true
        }
        if sectionNo == 4{
            buttonTitle4 = title
            isVelocityOptionShow4 = true
        }
    }
    func getVehicleNameValue(sectionNo: Int)->String{
        if sectionNo == 1{
            return vehicleName1
        }
        if sectionNo == 2{
            return vehicleName2
        }
        if sectionNo == 3{
            return vehicleName3
        }
        if sectionNo == 4{
            return vehicleName4
        }
        return ""
    }
    func getOldVehicleNameValue(sectionNo: Int)->String{
        if sectionNo == 1{
            return OldvehicleName1
        }
        if sectionNo == 2{
            return OldvehicleName2
        }
        if sectionNo == 3{
            return OldvehicleName3
        }
        if sectionNo == 4{
            return OldvehicleName4
        }
        return ""
    }
    func setVehicleNameValue(sectionNo: Int, value:String){
        if sectionNo == 1{
             vehicleName1 = value
        }
        if sectionNo == 2{
            vehicleName2 = value
        }
        if sectionNo == 3{
            vehicleName3 = value
        }
        if sectionNo == 4{
            vehicleName4 = value
        }
       
    }
    func setOldVehicleNameValue(sectionNo: Int, value:String){
        if sectionNo == 1{
            OldvehicleName1 = value
        }
        if sectionNo == 2{
            OldvehicleName2 = value
        }
        if sectionNo == 3{
            OldvehicleName3 = value
        }
        if sectionNo == 4{
            OldvehicleName4 = value
        }
    }
    func selectPlanet(planet:Planet, sectionNo:Int){
        if let index = planets.firstIndex(of: planet) {
            planets.remove(at: index)
        }
        selectedPlanets.append(planet)
        if sectionNo == 1{
            if selectedPlanet1 != nil{
                planets.append(selectedPlanet1!)
                if let index = selectedPlanets.firstIndex(of: selectedPlanet1!) {
                    selectedPlanets.remove(at: index)
                }
            }
            selectedPlanet1 = planet
            if selectedVelocity1 != nil {
                for i in 0...3{
                    if self.velocities1[i].name == selectedVelocity1!.name{
                        self.velocities1[i].total_no += 1
                       break
                    }
                     
                }
            }
            selectedVelocity1 = nil
            
        }
        if sectionNo == 2{
            if selectedPlanet2 != nil{
                planets.append(selectedPlanet2!)
                if let index = selectedPlanets.firstIndex(of: selectedPlanet2!) {
                    selectedPlanets.remove(at: index)
                }
            }
            selectedPlanet2 = planet
            if selectedVelocity2 != nil {
                for i in 0...3{
                   
                     if self.velocities2[i].name == selectedVelocity2!.name{
                        self.velocities2[i].total_no += 1
                         break
                    }
                      
                }
            }
            selectedVelocity2 = nil
        }
        if sectionNo == 3{
            if selectedPlanet3 != nil{
                planets.append(selectedPlanet3!)
                if let index = selectedPlanets.firstIndex(of: selectedPlanet3!) {
                    selectedPlanets.remove(at: index)
                }
            }
            selectedPlanet3 = planet
            if selectedVelocity3 != nil {
                for i in 0...3{
                    
                      if self.velocities3[i].name == selectedVelocity3!.name{
                        self.velocities3[i].total_no += 1
                          break
                    }
                     
                }
            }
            selectedVelocity3 = nil
        }
        if sectionNo == 4{
            if selectedPlanet4 != nil{
                planets.append(selectedPlanet4!)
                if let index = selectedPlanets.firstIndex(of: selectedPlanet4!) {
                    selectedPlanets.remove(at: index)
                }
            }
            selectedPlanet4 = planet
            if selectedVelocity4 != nil {
                for i in 0...3{
                    
                      if self.velocities4[i].name == selectedVelocity4!.name{
                        self.velocities4[i].total_no += 1
                          break
                    }
                }
            }
            selectedVelocity4 = nil
        }
        
        enableFindFalconButton()
    }
    func calculateTime(){
        timeTaken = 0
        if selectedVelocity1 != nil{
            timeTaken += Double(selectedPlanet1!.distance/selectedVelocity1!.speed)
        }
        if selectedVelocity2 != nil{
            timeTaken += Double(selectedPlanet2!.distance/selectedVelocity2!.speed)
        }
        if selectedVelocity3 != nil{
            timeTaken += Double(selectedPlanet3!.distance/selectedVelocity3!.speed)
        }
        if selectedVelocity4 != nil{
            timeTaken += Double(selectedPlanet4!.distance/selectedVelocity4!.speed)
        }
    }
    func didChangeIn(vel:Velocity, oldVel:Velocity?, sectionNo:Int)->Void{
        if sectionNo == 1{
            selectedVelocity1 = vel
           calculateTime()
        }
        if sectionNo == 2{
            selectedVelocity2 = vel
            calculateTime()
        }
        if sectionNo == 3{
            selectedVelocity3 = vel
            calculateTime()
        }
        if sectionNo == 4{
            selectedVelocity4 = vel
            calculateTime()
        }
        if self.velocities1[0].name == vel.name{
            self.velocities1[0] = vel
            self.velocities2[0] = vel
            self.velocities3[0] = vel
            self.velocities4[0] = vel
            
        }
        if self.velocities1[1].name == vel.name{
            self.velocities1[1] = vel
            self.velocities2[1] = vel
            self.velocities3[1] = vel
            self.velocities4[1] = vel
            selectedVelocity1 = vel
        }
        if self.velocities1[2].name == vel.name{
            self.velocities1[2] = vel
            self.velocities2[2] = vel
            self.velocities3[2] = vel
            self.velocities4[2] = vel
        }
        if self.velocities1[3].name == vel.name{
            self.velocities1[3] = vel
            self.velocities2[3] = vel
            self.velocities3[3] = vel
            self.velocities4[3] = vel
        }
        
        
        if let oldVelocity = oldVel{
            for i in 0...3{
                if self.velocities1[i].name == oldVelocity.name{
                    self.velocities1[i].total_no += 1
                }
                else  if self.velocities2[i].name == oldVelocity.name{
                    self.velocities2[i].total_no += 1
                }
                else  if self.velocities3[i].name == oldVelocity.name{
                    self.velocities3[i].total_no += 1
                }
                else  if self.velocities4[i].name == oldVelocity.name{
                    self.velocities4[i].total_no += 1
                }
            }
            
        }
        enableFindFalconButton()
    }
    
}
