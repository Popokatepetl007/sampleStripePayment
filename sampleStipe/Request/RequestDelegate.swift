//
//  RequestDelegate.swift
//  sampleStipe
//
//  Created by Артем on 31.05.2020.
//  Copyright © 2020 Артем. All rights reserved.
//

import Foundation

protocol RequestDelegate: class {
    func error_back(message: String)
    func test()
}
