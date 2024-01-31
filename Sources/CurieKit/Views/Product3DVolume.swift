//
//  Product3DVolume.swift
//  Curie
//
//  Created by Benji Dodgson on 1/27/24.
//

import SwiftUI
import RealityKit

struct Product3DVolume: View {
    
    @Environment(ViewModel.self) private var model

    var body: some View {
        
        @Bindable var model = model
        
        ZStack(alignment: Alignment(horizontal: .controlsGuide, vertical: .bottom)) {
            if let product = model.product {
                Model3D(url: product.url)
                    .alignmentGuide(.controlsGuide) { context in
                        context[HorizontalAlignment.center]
                    }
                    .dragRotation(yawLimit: .degrees(40), pitchLimit: .degrees(40))
                
                ProductControls()
                    .offset(y: 150)
            } else {
                ProgressView()
            }
        }
        .onDisappear(perform: {
            model.isShowingProduct = false
        })
    }
}

#Preview {
    Product3DVolume()
        .environment(ViewModel(with: MockCurieProductService()))
}
