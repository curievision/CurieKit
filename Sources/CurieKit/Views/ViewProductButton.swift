//
//  ViewButton.swift
//  Curie
//
//  Created by Benji Dodgson on 1/29/24.
//

import SwiftUI

/// A toggle that activates or deactivates the product volume.
struct ViewProductButton: View {
    @Environment(ViewModel.self) private var model
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        @Bindable var model = model
        
        Button(action: {
            model.isShowingProduct = true
        }, label: {
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10, content: {
                Image(systemName: "arkit")
                Text("View in your space")
            })
            .frame(width: 220, height: 44)
            .background(.white)
            .cornerRadius(22)
            .hoverEffect()
        })
        .buttonStyle(.plain)
        .foregroundColor(.black)
        .onChange(of: model.isShowingProduct) { _, isShowing in
            if isShowing {
                openWindow(id: CurieProductWindowIdentifier)
            } else {
                dismissWindow(id: CurieProductVolumeIdentifier)
            }
        }
        .glassBackgroundEffect(in: .rect(cornerRadius: 50))
    }
}

#Preview {
    ViewProductButton()
        .environment(ViewModel(with: MockCurieProductService()))
}
