//
//  RequestManager.swift
//  sampleStipe
//
//  Created by Артем on 31.05.2020.
//  Copyright © 2020 Артем. All rights reserved.
//

import Foundation

class RequestManager{
    weak var delegate: RequestDelegate?
    let config = URLSessionConfiguration.default

    init(d: RequestDelegate) {
        self.delegate = d
        self.config.httpAdditionalHeaders = self.additionalHeaders
    }

    init(){
        self.config.httpAdditionalHeaders = self.additionalHeaders
    }
    
    public typealias HTTPHeaders = [String: String]
    
    private let additionalHeaders = [
        "Accept": "application/json",
        "User-Agent": "Test-app (iPhone; iOS A - serials)",
        "cache-control": "no-cache"
    ]
    
    public enum HTTPMethod: String {
        case get
        case POST
        case put
        case delete
    }
    
    private let build_main_url = { (method: String)-> URL in
        return URL(string: "\(StringValue.m_url)\(method)")!
    }
    
    private func createRequest(url: URL, http_method: HTTPMethod) -> URLRequest{
        
        var request = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        
        request.httpMethod = http_method.rawValue
        request.addValue(StringValue.session_token, forHTTPHeaderField: "token")
        
        return request
    }
    
    func get(method: String, casus_url: String? = nil, main_url: Bool = true, success_run: @escaping ([String: AnyObject]) -> Void){
        
        let conf = config
        let session = URLSession.init(configuration: conf)
        let request: URLRequest = {
            return createRequest(url: build_main_url(method), http_method: .get)
        }()
        
        let task = session.dataTask(with: request){(data, request, error) in
            do{
                if let d = data {
                    let json = try JSONSerialization.jsonObject(with: d, options: [])
                    
                    if let message = json as? [String: AnyObject]{
                        success_run(message)
                    }
                }
            }catch{
                print("fail")
            }
        }
        
        task.resume()
    }
}
