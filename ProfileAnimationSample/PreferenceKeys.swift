//
//  PreferenceKeys.swift
//  ProfileAnimationSample
//
//  Created by Juanjo Corbalan on 19/5/24.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0.0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

struct AnchorKey: PreferenceKey {
    static var defaultValue: [AnyHashable : Anchor<CGRect>] = [:]

    static func reduce(value: inout [AnyHashable : Anchor<CGRect>], nextValue: () -> [AnyHashable : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
