//
//  CurieService.swift
//  
//
//  Created by Benji Dodgson on 1/31/24.
//

import Foundation

// The protocol conformance for objects wanting to retrieve `CurieProduct`'s
public protocol CurieAPIService {
    func getProduct(with productId: String) async throws -> CurieProduct?
}

struct CurieService: CurieAPIService {
    func getProduct(with productId: String) async throws -> CurieProduct? {
        try await _getProduct(with: productId)
    }
}
