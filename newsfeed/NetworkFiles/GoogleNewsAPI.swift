//
//  Constants.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 08.02.2021.
//


import Foundation

class GoogleNewsAPI {
    
    let baseUrl: String
    let apiKey: String
    let version: String
    let creator: URLCreator
    
    init(baseUrl: String, apiKey: String, version: String) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
        self.version = version
        creator = URLCreator(baseUrl: baseUrl, apiKey: apiKey, version: version)
    }
    
    func fetchNewsByRequest(_ googleNewsEverythingRequest : GoogleNewsEverythingRequest, completionHandler: @escaping (Result <NewsResponse, ErrorsFormatForHTTPSRequest> ) -> Void) {
        
        guard let url = creator.createURL(endpoint: Endpoints.everything, queryItems: googleNewsEverythingRequest) else {
            let error = ErrorsFormatForHTTPSRequest(status: "Error",
                                                    code: "Status code ",
                                                    message: "Can`t create URL with input endpoint and QueryItems")
            DispatchQueue.main.async {
                completionHandler(.failure(error))
                print(" NewsAPIManager -> fetchEverythingRequest -> Can`t create URL with input endpoint and QueryItems ")
            }
            
            
            return
        }
        
        self.fetchData(url: url) { response in
            DispatchQueue.main.async {
                completionHandler(response)
            }
          
            
        }
    }
    
    private func fetchData(url: URL, completionHandler: @escaping (Result <NewsResponse, ErrorsFormatForHTTPSRequest> ) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                guard let data = data  else {
                    let error = ErrorsFormatForHTTPSRequest(status: "Error",
                                                            code: String( response.statusCode),
                                                            message: "There is no data from this URL")
                    completionHandler(.failure(error))
                    print(" NewsAPIManager -> fetchData -> There is no data from this URL \n \(response.statusCode)")
                    return
                }
                do {
                    let responseModel = try JSONDecoder().decode(NewsResponse.self, from: data)
                    
                    completionHandler(.success(responseModel))
                    
                    
                } catch {
                    completionHandler(.failure(
                                        ErrorsFormatForHTTPSRequest(status: "Error",
                                                                    code: String( response.statusCode),
                                                                    message: error.localizedDescription)))
                    print(" NewsAPIManager -> fetchData -> error in decoding \n \(error)")
                }
            }
        }
        task.resume()
    }
    
}

