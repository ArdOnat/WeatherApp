//
//  URLSessionNetworkLayer.swift
//  WeatherApp
//
//  Created by Arda Onat on 24.08.2021.
//

import Foundation
import NetworkModule

class URLSessionNetworkLayer: NetworkLayer {
    var defaultURLParameters: Parameters?
    
    var defaultBodyParameters: Parameters?
    
    required init(defaultURLParameters: Parameters?, defaultBodyParameters: Parameters?) {
        self.defaultURLParameters = defaultURLParameters
        self.defaultBodyParameters = defaultBodyParameters
    }
    
    func request<T>(_ request: Request, queue: DispatchQueue = .main, completion: @escaping (Result<T, NetworkError>) -> ()) where T : Decodable {

        guard let request = try? self.buildRequest(from: request) else {
            return completion(.failure(.invalidRequest))
        }
        
        queue.async {
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let _ = error {
                        completion(.failure(.custom(errorText: error?.localizedDescription ?? "An error occured")))
                    }
                    else {
                        if let httpResponse = response as? HTTPURLResponse {
                            switch httpResponse.statusCode {
                            case 200...299:
                                break
                            default:
                                completion(.failure(.invalidStatusCode))
                            }
                        }
                        else {
                            completion(.failure(.custom(errorText: "Invalid response.")))
                        }
                        
                        if let data = data {
                            let response = try? JSONDecoder().decode(T.self, from: data)
                            
                            if let response = response {
                                completion(.success(response))
                            }
                            else {
                                completion(.failure(.decodingFailed))
                            }
                        }
                    }
                })
            task.resume()
        }

    }
    
    fileprivate func buildRequest(from requestToMake: NetworkModule.Request) throws -> URLRequest {
        guard let baseURL = URL(string: requestToMake.apiEnvironment.baseURL) else {
            throw NetworkError.invalidBaseURL
        }
        
        var request = URLRequest(url: baseURL.appendingPathComponent(requestToMake.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = requestToMake.httpMethod.rawValue
        
        do {
            if let additionalHeaders = requestToMake.httpHeaders {
                self.addAdditionalHeaders(additionalHeaders, request: &request)
            }
            try self.configureParameters(bodyParameters: requestToMake.bodyParameters, urlParameters: requestToMake.urlParameters, request: &request)
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if var bodyParameters = bodyParameters {
                if let defaultBodyParameters = self.defaultBodyParameters {
                    for (key, value) in defaultBodyParameters {
                        bodyParameters[key] = value
                    }
                }
                
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            
            if var urlParameters = urlParameters {
                if let defaultURLParameters = self.defaultURLParameters {
                    for (key, value) in defaultURLParameters {
                        urlParameters[key] = value
                    }
                }
                
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: NetworkModule.HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}
