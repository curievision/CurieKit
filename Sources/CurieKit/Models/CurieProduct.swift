//
//  CurieProduct.swift
//
//
//  Created by Benji Dodgson on 1/30/24.
//

import Foundation

/// The model that represents the 3D asset for display
public struct CurieProduct {
    /// The unique identifier for the product. Matches the identifier on curie.app
    let id: String
    /// The file url to the locally stored 3D asset
    let url: URL
    /// The brand name of the product
    let brandName: String = ""
    /// The public name of the product
    let name: String
    /// A description of the product
    let descripton: String = ""
    /// A date representing when the product was first accessed by the user
    let timestamp: Date
}
