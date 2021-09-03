//
//  AFNetworkLayer.swift
//  WeatherApp
//
//  Created by Arda Onat on 23.08.2021.
//

import Foundation
import NetworkModule
import Alamofire

class AFNetworkLayer: NetworkLayer {
    
    public var defaultURLParameters: Parameters?
    public var defaultBodyParameters: Parameters?
    
    required init(defaultURLParameters: Parameters? = nil, defaultBodyParameters: Parameters? = nil ) {
        self.defaultURLParameters = defaultURLParameters
        self.defaultBodyParameters = defaultBodyParameters
    }
    
    func request<T>(_ request: NetworkModule.Request, queue: DispatchQueue?, completion: @escaping (Result<T, NetworkError>) -> ()) where T : Decodable {
        guard let request = try? self.buildRequest(from: request) else {
            return completion(.failure(.invalidRequest))
        }
        
        AF.request(request).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let decodableResult):
                completion(.success(decodableResult))
            case .failure(_):
                completion(.failure(.invalidStatusCode))
            }
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


protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

class URLParameterEncoder: ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url =  urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}

class JSONParameterEncoder: ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
