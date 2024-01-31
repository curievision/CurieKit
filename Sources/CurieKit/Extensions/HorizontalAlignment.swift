//
//  HorizontalAlignment.swift
//  Curie
//
//  Created by Benji Dodgson on 1/29/24.
//

import Foundation
import SwiftUI

extension HorizontalAlignment {
    /// A custom alignment to center the controls under the product.
    private struct ControlsAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
    }

    /// A custom alignment guide to center the controls under the product.
    static let controlsGuide = HorizontalAlignment(
        ControlsAlignment.self
    )
}
