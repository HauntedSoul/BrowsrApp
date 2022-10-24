//
//  SeparatorView.swift
//  BrowsrApp
//
//  Created by Vitor Dinis on 24/10/2022.
//

import SwiftUI

struct SeparatorView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.gray)
            .opacity(0.3)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }
}
