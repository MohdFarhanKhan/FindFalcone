//
//  VewModelTest.swift
//  FindFalcone
//
//  Created by Najran Emarah on 03/10/1444 AH.
//

import XCTest
@testable import FindFalcone
final class VewModelTest: XCTestCase {
    var viewModelObject:ViewModelClass?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModelObject = ViewModelClass()
        mockValues()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModelObject!.resetAll()
        viewModelObject = nil
    }
   // selectPlanet didChangeIn
    func testSelectPlanet() throws{
        let sectionNo = 1
        let selectedPlanet = Planet(name:"Donlon",distance:100)
        let selectedVehicle = Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2)
        viewModelObject?.selectPlanet(planet: selectedPlanet, sectionNo: sectionNo)
        XCTAssert(viewModelObject?.planetVehicleArray[sectionNo-1].planet == selectedPlanet, "selectedPlanet is not equal to viewModelObject.selectedPlanet")
        
    }
   
    //didChangeIn(vel:Velocity, oldVel:Velocity?, sectionNo:Int)->Void{
    func testDidChangeIn() throws{
        let sectionNo = 1
        let selectedPlanet = Planet(name:"Donlon",distance:100)
        let selectedVehicle = Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2)
        viewModelObject?.selectPlanet(planet: selectedPlanet, sectionNo: sectionNo)
        
       viewModelObject?.didChangeIn(vel: selectedVehicle, oldVel: nil, sectionNo: sectionNo)
        XCTAssert(viewModelObject?.planetVehicleArray[sectionNo-1].vehicle == selectedVehicle, "selectedVehicle is not equal to viewModelObject.selectedVehicle")
        
    }
    //getVehicleNameValue
    func testGetVehicleNameValue() throws{
        let sectionNo = 1
        let selectedPlanet = Planet(name:"Donlon",distance:100)
        let selectedVehicle = Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2)
        viewModelObject?.selectPlanet(planet: selectedPlanet, sectionNo: sectionNo)
        
       viewModelObject?.didChangeIn(vel: selectedVehicle, oldVel: nil, sectionNo: sectionNo)
       
        XCTAssert(viewModelObject?.getVehicleNameValue(sectionNo: sectionNo) == selectedVehicle.name, "selectedVehicle.name is not equal to viewModelObject.getVehicleNameValue(sectionNo: 1)")
        
    }
    //getOldVehicleNameValue(sectionNo: Int)
    func testGetOldVehicleNameValue() throws{
        let sectionNo = 1
        let oldVehicle = Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2)
       
        let selectedPlanet = Planet(name:"Donlon",distance:100)
        let selectedVehicle = Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4)
        viewModelObject?.selectPlanet(planet: selectedPlanet, sectionNo: sectionNo)
        
       viewModelObject?.didChangeIn(vel: oldVehicle, oldVel: nil, sectionNo: sectionNo)
        viewModelObject?.didChangeIn(vel: selectedVehicle, oldVel: nil, sectionNo: sectionNo)
       
        XCTAssert(viewModelObject?.getOldVehicleNameValue(sectionNo: sectionNo) == oldVehicle.name, "oldVehicle.name is not equal to viewModelObject.getOldVehicleNameValue(sectionNo: 1)")
        
    }
    //getDataFromAPI
    func testGetDataFromAPI() async throws {
        await viewModelObject?.getDataFromAPI()
        XCTAssertNotNil(self.viewModelObject?.authToken?.token)
        XCTAssertNotNil(viewModelObject?.planets)
        XCTAssertNotNil(viewModelObject?.velocities)
    }
   
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func mockValues(){
        viewModelObject!.velocities = [Velocity(name:"Space pod",total_no:2,max_distance:200,speed:2),Velocity(name:"Space rocket",total_no:1,max_distance:300,speed:4),Velocity(name:"Space shuttle",total_no:1,max_distance:400,speed:5),Velocity(name:"Space ship",total_no:2,max_distance:600,speed:10)]
       
        viewModelObject!.planets = [Planet(name:"Donlon",distance:100),Planet(name:"Enchai",distance:200),Planet(name:"Jebing",distance:300),Planet(name:"Sapir",distance:400),Planet(name:"Lerbin",distance:500),Planet(name:"Pingasor",distance:600)]
        viewModelObject?.initPlanetVehicle()
       
    }

}
