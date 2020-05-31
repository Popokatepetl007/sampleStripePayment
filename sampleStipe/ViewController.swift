//
//  ViewController.swift
//  sampleStipe
//
//  Created by Артем on 31.05.2020.
//  Copyright © 2020 Артем. All rights reserved.
//

import UIKit
import Stripe

class ViewController: UIViewController, RequestDelegate, STPPaymentContextDelegate {
    
    
    private var paymentContext: STPPaymentContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customerContext = STPCustomerContext(keyProvider: MyAPIClient())
        self.paymentContext = STPPaymentContext(customerContext: customerContext)
        self.paymentContext?.delegate = self
        self.paymentContext?.hostViewController = self
        self.paymentContext?.paymentAmount = 5000
    }
    
    //MARK: - action methods
    
    @IBAction func presentView(_ sender: Any) {
        self.paymentContext?.presentPaymentOptionsViewController()
    }
    
    @IBAction func pushView(_ sender: Any) {
        self.paymentContext?.pushPaymentOptionsViewController()
    }
    
    @IBAction func submit(_ sender: Any) {
        self.paymentContext?.requestPayment()
    }
    
    
    //MARK: - delegate methods
    
    func error_back(message: String) {
        print()
    }
    
    func test() {
        print()
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print()
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        MyAPIClient().createPaymentIntent { (data) in
            if let clientSecret = data{
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId

                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
                    switch status {
                    case .succeeded:
                        MyAPIClient().complitePayment { (result) in
                            //some action true on false
                        }
                        completion(.success, nil)
                    case .failed:
                        completion(.error, error)
                    case .canceled:
                        completion(.userCancellation, nil)
                    @unknown default:
                        completion(.error, nil)
                    }
                }
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        print()
    }


}

