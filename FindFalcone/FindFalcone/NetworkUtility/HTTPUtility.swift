//
//  HTTPUtility.swift
//  FalconFind
//
//  Created by Najran Emarah on 19/09/1444 AH.
//

import Foundation
enum httpError : Error {
    case jsonDecoding
    case noData
    case nonSuccessStatusCode
    case serverError
    case emptyCollection
    case emptyObject
    case notSuccess
    case tokenError
}



final class HttpUtility {

    static let shared: HttpUtility = HttpUtility()
    private init() {}
    var errorString = ""
    func performOperation<T:Decodable>(request: URLRequest, response: T.Type) async throws -> T{

        do {
            let (serverData, serverUrlResponse) = try await URLSession.shared.data(for:request)
            let responseString = String(data: serverData, encoding: .utf8)
            errorString = responseString ?? ""
            guard let httpStausCode = (serverUrlResponse as? HTTPURLResponse)?.statusCode,
                  (200...299).contains(httpStausCode) else {
                      throw httpError.nonSuccessStatusCode
                  }
            if responseString!.contains("planet_name") == false && responseString!.contains("status"){
                throw httpError.notSuccess
            }
            else if responseString!.contains("planet_name") == false && responseString!.contains("status") == false && responseString!.contains("error") {
                throw httpError.tokenError
            }
             
            return try JSONDecoder().decode(response.self, from: serverData)

        } catch  {
            throw error
        }
    }
}
