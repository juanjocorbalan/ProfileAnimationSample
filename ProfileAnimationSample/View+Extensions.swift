//
//  View+Extensions.swift
//  ProfileAnimationSample
//
//  Created by Juanjo Corbalan on 21/5/24.
//

import SwiftUI

struct ScrollOffset: ViewModifier {
    let coordinateNamespace: AnyHashable
    let completion: (CGFloat) -> Void

    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: OffsetKey.self, value: proxy.frame(in: .named(coordinateNamespace)).minY)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            }
    }
}

extension View {
    func offsetMonitor(cf coordinateNamespace: AnyHashable, completion: @escaping (CGFloat) -> Void) -> some View {
        self.modifier(ScrollOffset(coordinateNamespace: coordinateNamespace, completion: completion))
    }
}
