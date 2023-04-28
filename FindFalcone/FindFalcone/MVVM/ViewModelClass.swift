//
//  ViewModel.swift
//  FalconFind
//
//  Created by Najran Emarah on 03/10/1444 AH.
//

import Foundation

class  ViewModelClass:ObservableObject{
    var authToken : AuthToken?
    var totalSection: Int = 4
    @Published var successPlanet:SuccessPlanet?
    @Published var errorString: String?
    @Published var error: httpError?
    
    @Published var timeTaken :Double = 0
    @Published var planetVehicleArray :[PlanetVehicleSection] = []
    @Published var velocities :[Velocity] = []
    @Published var planets :[Planet] = []
    var allPlanets : [Planet] = []
   
    @Published var isFindFalconEnable = false
    func mockValues(){
        /*
       velocities1 = [Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2),Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4),Velocity(name:"Space shuttle",total_no:1,max_distance:400,speed:5),Velocity(name:"Space ship",total_no:2,max_distance:600,speed:10)]
      velocities2 = [Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2),Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4),Velocity(name:"Space shuttle",total_no:1,max_distance:400,speed:5),Velocity(name:"Space ship",total_no:2,max_distance:600,speed:10)]
       velocities3 = [Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2),Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4),Velocity(name:"Space shuttle",total_no:1,max_distance:400,speed:5),Velocity(name:"Space ship",total_no:2,max_distance:600,speed:10)]
        velocities4 = [Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2),Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4),Velocity(name:"Space shuttle",total_no:1,max_distance:400,speed:5),Velocity(name:"Space ship",total_no:2,max_distance:600,speed:10)]
        planets = [Planet(name:"Donlon",distance:100),Planet(name:"Enchai",distance:200),Planet(name:"Jebing",distance:300),Planet(name:"Sapir",distance:400),Planet(name:"Lerbin",distance:500),Planet(name:"Pingasor",distance:600)]
         */
    }
    
    func findFalcone() async{
       

        var json: [String: Any] = [:]
        json["token"] = authToken!.token
        var selPlanets :[String] = []
        var selVehicles :[String] = []
        for planetVehicle in planetVehicleArray{
            selPlanets.append(planetVehicle.planet!.name)
            selVehicles.append(planetVehicle.vehicle!.name)
        }
        json["planet_names"] = selPlanets
        json["vehicle_names"] = selVehicles
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
                self.allPlanets = pnts
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
                self.velocities = vels
               
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
    func initPlanetVehicle(){
        self.planetVehicleArray.removeAll()
        for _ in 1...totalSection{
            self.planetVehicleArray.append(PlanetVehicleSection())
        }
        
    }
    func resetAll() {
        
        self.planetVehicleArray.removeAll()
        initPlanetVehicle()
        successPlanet = nil
        errorString = ""
        error = nil
      
       
        
        timeTaken  = 0
        Task{
            do{
                await getDataFromAPI()
            }
            catch{
                
            }
        }
        
        isFindFalconEnable = false
    }
    func enableFindFalconButton(){
        var findButtonEnable = true
        if planetVehicleArray.count >= totalSection {
            for planetVehicle in self.planetVehicleArray{
                if planetVehicle.planet == nil || planetVehicle.vehicle == nil{
                    findButtonEnable = false
                }
            }
           
        }
        else{
            findButtonEnable = false
        }
        isFindFalconEnable = findButtonEnable
        
    }
    func changeButtonTitle(title:String, sectionNo:Int){
        planetVehicleArray[sectionNo-1].buttonTitle = title
        planetVehicleArray[sectionNo-1].isVehicleShowOption = true
        
    }
    func getVehicleNameValue(sectionNo: Int)->String{
        if sectionNo <= self.totalSection{
            return planetVehicleArray[sectionNo-1].vehicle?.name ?? ""
        }
       
        return ""
    }
    func getOldVehicleNameValue(sectionNo: Int)->String{
        if sectionNo <= self.totalSection{
            return planetVehicleArray[sectionNo-1].oldVehicle?.name ?? ""
        }
        return ""
    }
    func putPlanetInPlanets(planet:Planet ){
        guard let index = allPlanets.firstIndex(of: planet)else{
            return
        }
        if index == 0 || planets.count <= 0{
            planets.insert(planet, at: 0)
        }
       else if  index == allPlanets.count-1{
            planets.append(planet)
        }
        else{
            var isFoiund = false
            for i in (index+1)...(allPlanets.count-1){
                for j in 0...(planets.count-1){
                    if allPlanets[i] == planets[j]{
                        if j == 0{
                            planets.insert(planet, at: 0)
                        }
                        else{
                            planets.insert(planet, at: j-1)
                        }
                     
                        isFoiund = true
                        break
                    }
                }
                if isFoiund{
                   
                    break
                }
            }
            if !isFoiund{
                print("Element not ")
                planets.append(planet)
               
            }
        }
        
    }
    func selectPlanet(planet:Planet, sectionNo:Int){
        if let index = planets.firstIndex(of: planet) {
            planets.remove(at: index)
        }
        
        if sectionNo <= self.totalSection{
            if planetVehicleArray[sectionNo-1].planet != nil{
                    putPlanetInPlanets(planet: planetVehicleArray[sectionNo-1].planet!)
            }
            planetVehicleArray[sectionNo-1].oldPlanet =  planetVehicleArray[sectionNo-1].planet
            planetVehicleArray[sectionNo-1].planet = planet
            planetVehicleArray[sectionNo-1].buttonTitle = planet.name
            if planetVehicleArray[sectionNo-1].vehicle != nil{
                for i in 1...velocities.count{
                    if self.velocities[i-1].name == planetVehicleArray[sectionNo-1].vehicle!.name{
                        self.velocities[i-1].total_no += 1
                       break
                    }
                     
                }
            }
            planetVehicleArray[sectionNo-1].oldVehicle = nil
            planetVehicleArray[sectionNo-1].vehicle = nil
        }
      
        
        enableFindFalconButton()
    }
    func calculateTime(){
        
        timeTaken = 0
        for planetVehicle in planetVehicleArray{
            if let planet = planetVehicle.planet,let vehicle = planetVehicle.vehicle{
                timeTaken += Double(planet.distance/vehicle.speed)
            }
        }
       
    }
    func didChangeIn(vel:Velocity, sectionNo:Int)->Void{
        planetVehicleArray[sectionNo-1].oldVehicle =  planetVehicleArray[sectionNo-1].vehicle
        planetVehicleArray[sectionNo-1].vehicle = vel
        if  let oldV = planetVehicleArray[sectionNo-1].oldVehicle{
            for i in 1...velocities.count{
                if self.velocities[i-1].name == oldV.name{
                    self.velocities[i-1].total_no += 1
                }
                
            }
        }
        calculateTime()
       
        for i in 1...velocities.count{
            if self.velocities[i-1].name == vel.name{
                self.velocities[i-1] = vel
            }
        }
       
       
       
        enableFindFalconButton()
    }
    func getButtonTitle( sectionNo:Int)->String{
        if planetVehicleArray.count <= 0{
            initPlanetVehicle()
        }
       return planetVehicleArray[sectionNo-1].buttonTitle
    }
    func getVehicleShowOption(sectionNo:Int)->Bool{
        if planetVehicleArray.count <= 0{
            initPlanetVehicle()
        }
        return planetVehicleArray[sectionNo-1].isVehicleShowOption
    }
    
}
