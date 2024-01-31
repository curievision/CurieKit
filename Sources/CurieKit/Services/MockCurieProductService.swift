//
//  MockCurieProductService.swift
//
//
//  Created by Benji Dodgson on 1/30/24.
//

import Foundation

class MockCurieProductService: ProductAPIService {
    func getProduct(with productId: String) async throws -> CurieProduct? {
        return CurieProduct(id: "65a9a1913baa11131f202df8",
                            url: URL(fileURLWithPath: "/Users/benjidodgson/Desktop/Xcode Projects/Curie/Curie/Shared/Preview Content/Air-Jordan-1-Retro-High-OG-Royal-Reimagined.usdz"),
                            name: "Air-Jordan-1-Retro-High-OG-Royal-Reimagined",
                            timestamp: Date())
    }
}
