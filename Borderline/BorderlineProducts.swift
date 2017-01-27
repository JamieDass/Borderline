//
//  BorderlineProducts.swift
//  Borderline
//
//  Created by James Dassoulas on 2017-01-27.
//  Copyright © 2017 Jetliner. All rights reserved.
//

import Foundation

public struct BorderlineProducts {
    
    public static let USStates = "co.jetliner.borderline.usstates"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [BorderlineProducts.USStates]
    
    public static let store = IAPHelper(productIds: BorderlineProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
