//
//  SettingsRowView.swift
//  ProfileAnimationSample
//
//  Created by Juanjo Corbalan on 21/5/24.
//

import SwiftUI

struct SettingsRowView: View {
    let item: String
    let systemImage: String
    let color: Color
    var showDivider: Bool = true

    var body: some View {
        NavigationLink { Text(item) } label: {
            VStack(spacing: 0) {
                HStack {
                    Label(title: { Text(item) },
                          icon: { Image(systemName: systemImage)
                            .frame(width: 32, height: 32)
                            .background {
                                color
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                            .foregroundStyle(.white)
                    })
                    Spacer()
                    Image(systemName: "chevron.right").font(Font.system(.footnote).weight(.semibold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                Divider()
                    .frame(height: 1)
                    .overlay(.background.opacity(0.2))
                    .padding(.leading, 60)

            }
        }
    }
}

#Preview {
    SettingsRowView(item: "Settings item", systemImage: "bell", color: .blue)
}
