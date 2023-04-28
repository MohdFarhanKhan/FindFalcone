//
//  APITest.swift
//  FindFalconeTests
//
//  Created by Najran Emarah on 04/10/1444 AH.
//

import XCTest
@testable import FindFalcone
final class APITest: XCTestCase {
    var viewModelObject:ViewModelClass?
    override func setUpWithError()  throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModelObject = ViewModelClass()
       
       
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModelObject = nil
    }
    func testFindRequest() {
       
        let jsonDict: [String: Any] = ["token": "nEDggQNqpisarcJcHAgZBiqHQWjhlmmj",
                                   "planet_names": ["Donlon","Enchai", "Jebing","Sapir"],
                                   "vehicle_names": ["Space pod","Space pod", "Space rocket","Space ship"]]
       
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict)

        let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String
       
        
        // create post request
        let url = Service.findFalconeURL
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
       
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
       
        urlRequest.httpBody = jsonString.data(using: .utf8)
        
        XCTAssertEqual(urlRequest.url, URL(string: "https://findfalcone.geektrust.com/find"))
        }
    func testFindRequestResult() async {
      
        let expectation = self.expectation(description: "testFindRequestResult")
            await viewModelObject!.getDataFromAPI()
       
            var jsonDict: [String: Any] = [:]
            jsonDict["token"] = viewModelObject!.authToken!.token
            var selPlanets :[String] = []
            var selVehicles :[String] = []
            for i in 0...3{
                selPlanets.append((viewModelObject?.planets[i].name)!)
                
            }
            for i in 0...3{
                selVehicles.append((viewModelObject?.velocities[i].name)!)
                
            }
            
            jsonDict["planet_names"] = selPlanets
            jsonDict["vehicle_names"] = selVehicles
            
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict)
            
            let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String
            
            
            // create post request
            let url = Service.findFalconeURL
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            
            urlRequest.httpBody = jsonString.data(using: .utf8)
            
            do{
                let plnt = try await HttpUtility.shared.performOperation(request: urlRequest, response: SuccessPlanet.self)
                
                await MainActor.run {
                    viewModelObject!.successPlanet = plnt
                    XCTAssertNotNil(viewModelObject?.successPlanet)
                    expectation.fulfill()
                }
                
            }
            catch{
                DispatchQueue.main.async { [self] in
                    self.viewModelObject!.error = error as? httpError
                    viewModelObject!.errorString = HttpUtility.shared.errorString
                    XCTAssertNotNil(viewModelObject?.errorString)
                    expectation.fulfill()
                }
            }
        await waitForExpectations(timeout: 5,handler: nil)
       
        }
    func testTokenRequest() {
       
        var urlRequest = URLRequest(url:  Service.tokenURL)
       urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
       urlRequest.httpMethod = "POST"
        let postString = ""
        urlRequest.httpBody = postString.data(using: .utf8)

        XCTAssertEqual(urlRequest.url, URL(string: "https://findfalcone.geektrust.com/token"))
        }
    func testVehiclesRequest() async {
        
        await viewModelObject!.getVelocities()
       
        XCTAssertNotNil(viewModelObject?.velocities)
       
       
        }
    func testPlanetsRequest() async {
        await viewModelObject!.getPlanets()
        XCTAssertNotNil(viewModelObject?.planets)
       
        }
    func testGetTokenRequestResult() async {
        await viewModelObject!.getToken()
        XCTAssertNotNil(viewModelObject?.authToken?.token)
       
        }
   

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
