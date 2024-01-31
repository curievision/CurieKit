//
//  CurieViewModel.swift
//
//
//  Created by Benji Dodgson on 1/30/24.
//

import Foundation

/// The data that the app uses to configure its views. Conforms to @Observable
@Observable
public class ViewModel {
    
    var productId: String? {
        didSet {
            Task { [productId]
                guard let productId else { return }
                product = try await service.getProduct(with: productId)
            }
        }
    }
    
    private(set) var product: CurieProduct?
    
    let service: ProductAPIService
    var isShowingProduct: Bool = false
    
    public required init(with service: ProductAPIService) {
        self.service = service
    }
}
