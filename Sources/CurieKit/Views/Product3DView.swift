//
//  Product3DView.swift
//  Curie
//
//  Created by Benji Dodgson on 1/25/24.
//

import SwiftUI
import RealityKit

private let modelDepth: Double = 150

struct Product3DView: View {
    
    @Environment(ViewModel.self) private var model
    @Environment(\.openWindow) private var openWindow
    
    let orientation: SIMD3<Double> = [0.15, 0, 0.15]
    let scale: Double = 0.5
    let backgroundColor: Color = .gray

    var body: some View {
        
        @Bindable var model = model
        
        ZStack(content: {
            backgroundColor
            ZStack(alignment: Alignment(horizontal: .controlsGuide, vertical: .bottom)) {
                if let product = model.product {
                    ProductView(product: product, orientation: orientation)
                        .alignmentGuide(.controlsGuide) { context in
                            context[HorizontalAlignment.center]
                        }
                        .offset(z: modelDepth)
                        .frame(width: 300, height: 200, alignment: .center)
                        .dragRotation(yawLimit: .degrees(20), pitchLimit: .degrees(20))
                    
                    ViewProductButton()
                        .offset(y: 100)
                } else {
                    ProgressView()
                }
            }
        })
    }
}

/// A 3D product loaded from the product service
private struct ProductView: View {
    
    let product: CurieProduct
    let orientation: SIMD3<Double>
    
    var body: some View {
        GeometryReader(content: { geometry in
            Model3D(url: product.url) { model in
                model.resizable()
                    .scaledToFit()
                    .rotation3DEffect(
                        Rotation3D(
                            eulerAngles: .init(angles: orientation, order: .xyz)
                        )
                    )
                    .frame(depth: modelDepth)
                    .offset(z: -modelDepth / 2)
                    .accessibilitySortPriority(1)
            } placeholder: {
                ProgressView()
                    .offset(z: -modelDepth * 0.75)
            }
        })
    }
}

#Preview {
    Product3DView()
        .environment(ViewModel(with: MockCurieProductService()))
}
