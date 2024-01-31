//
//  VolumeControls.swift
//  Curie
//
//  Created by Benji Dodgson on 1/29/24.
//

import SwiftUI

/// Controls that people can use to manipulate the globe in a volume.
struct ProductControls: View {
    @Environment(ViewModel.self) private var model

    var body: some View {
        @Bindable var model = model
        
        HStack(alignment: .center, spacing: 10, content: {
            Button(action: {
                // Do something?
            }, label: {
                Text("Place Bid")
                    .frame(width: 150, height: 44)
                    .background(.white)
                    .cornerRadius(22)
                    .hoverEffect()
            })
            .buttonStyle(.plain)
            .foregroundColor(.black)
            
            Button(action: {
                // Do something?
            }, label: {
                Text("Buy for $999").frame(width: 150, height: 44).background(.green).cornerRadius(22).hoverEffect()
            })
            .buttonStyle(.plain)
            .foregroundColor(.white)
        })
        .padding(12)
        .glassBackgroundEffect(in: .rect(cornerRadius: 50))
    }
}

#Preview {
    ProductControls()
        .environment(ViewModel(with: MockCurieProductService()))
}
