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
    override func setUpWithError() throws {
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
       
        XCTAssertNotNil(viewModelObject?.velocities1)
        XCTAssertNotNil(viewModelObject?.velocities2)
        XCTAssertNotNil(viewModelObject?.velocities3)
        XCTAssertNotNil(viewModelObject?.velocities4)
       
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
