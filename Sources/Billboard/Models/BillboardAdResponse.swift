//
//  BillboardAdResponse.swift
//
//
//  Created by Hidde van der Ploeg on 30/06/2023.
//

import Foundation

@available(iOS 15.0, *)
public struct BillboardAdResponse : Codable {
    let ads : [BillboardAd]
}
