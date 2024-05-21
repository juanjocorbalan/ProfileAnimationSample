//
//  SettingsView.swift
//  ProfileAnimationSample
//
//  Created by Juanjo Corbalan on 20/5/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Label("Change profile photo", systemImage: "camera")
                .foregroundStyle(.link)
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(.lightBlue))
                    .padding(.bottom, 25)

            SettingsRowView(item: "My profile", systemImage: "person", color: .red, showDivider: false)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(.lightBlue))
                .padding(.bottom, 25)

            VStack {
                ForEach(1...20, id: \.self) { i in
                    SettingsRowView(item: "Setting \(i)", systemImage: "bell", color: .orange, showDivider: i != 20)
                }
            }
            .padding(.vertical, 6)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(.lightBlue))
        }
        .padding()
        .foregroundStyle(.white)
    }
}

#Preview {
    ScrollView(.vertical) {
        SettingsView()
    }
}
