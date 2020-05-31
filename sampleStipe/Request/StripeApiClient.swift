//
//  StripeApiClient.swift
//  sampleStipe
//
//  Created by Артем on 31.05.2020.
//  Copyright © 2020 Артем. All rights reserved.
//

import Foundation

import Stripe

class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    
    public enum HTTPMethod: String {
        case get
        case POST
        case put
        case delete
    }
    
    private let build_main_url = { (method: String)-> URL in
        return URL(string: "\(StringValue.m_url)\(method)")!
    }

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = build_main_url(StringValue.ephemeral_key_method)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [URLQueryItem(name: "api_version", value: apiVersion)]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.addValue(StringValue.session_token, forHTTPHeaderField: "token")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
                completion(nil, error)
                return
            }
            let d_response = json!["data"] as? [String: Any]
            if let s = d_response {
                let f_response = s["ephemeral_key"] as? [String: Any]
                completion(f_response, nil)
            }
            
        })
        task.resume()
    }
    
    func createPaymentIntent(completion: @escaping (String?) -> Void){
        let url = build_main_url(StringValue.payment_intent_method)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(StringValue.session_token, forHTTPHeaderField: "token")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
                return
            }
            if let response_text = json{
                let data = response_text["data"] as? [String: String]
                if let d = data{
                    completion(d["client_secret"])
                }else{
                    completion(nil)
                }
            }
            
        })
        task.resume()
    }
    
    func complitePayment(completion: @escaping (Bool) -> Void){
        let url = build_main_url(StringValue.sabmit_method)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(StringValue.session_token, forHTTPHeaderField: "token")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
                return
            }
            
            if let response_text = json{
                let data = response_text["data"] as? [String: Any]
                if let d = data{
                    completion(d["result"] as! Bool)
                }else{
                    completion(false)
                }
            }
            
        })
        task.resume()
    }
    
}
