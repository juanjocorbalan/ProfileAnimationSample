//
//  ProfileView.swift
//  ProfileAnimationSample
//
//  Created by Juanjo Corbalan on 21/5/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var offset: CGFloat = 0.0
    @State private var scaleUpHeader: CGFloat = 0.0
    @State private var scaleDownImage: CGFloat = 0.0
    @State private var isExpanded: Bool = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    // - MARK: View settings
    let headerMinHeight: CGFloat = 330.0
    let imageMaxHeight: CGFloat = 130.0
    let barHeight: CGFloat = 50.0
    let maxOffsetThreshold: CGFloat = 80.0
    let minOffsetThreshold: CGFloat = 25.0

    var body: some View {
            GeometryReader { proxy in
                var titleBarHeight: CGFloat {
                    proxy.safeAreaInsets.top + barHeight
                }

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        ZStack(alignment: .top) {
                            headerImageView(in: proxy)
                            headerTextsView()
                                .frame(maxHeight: .infinity, alignment: .bottom)
                        }
                        .padding(.top, isExpanded ? 0 : titleBarHeight - 10)
                        .scaleEffect(scaleUpHeader, anchor: .top)
                        .offset(y: isExpanded && offset >= 0 ? -offset : 0)
                        .frame(minHeight: headerMinHeight)

                        SettingsView()
                    }
                    .animation(.snappy(duration: 0.2), value: isExpanded)
                    .sensoryFeedback(.impact, trigger: isExpanded)
                    .offsetMonitor(cf: "mainScroll", completion: viewAdjustments)
                }
                .coordinateSpace(name: "mainScroll")
                .backgroundPreferenceValue(AnchorKey.self) { anchors in
                    backgroundCanvasView(safeArea: proxy.safeAreaInsets, anchors: anchors)
                }

                .background(.darkBlue)
                .foregroundStyle(.white)
                .overlay {
                    ZStack(alignment: .top) {
                        Rectangle()
                            .fill(.darkBlue)
                            .frame(height: 15)
                            .opacity(isExpanded ? 0 : 1)
                        titleView(in: proxy)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .offset(y: min(max(-offset - maxOffsetThreshold * 3, 0.0), titleBarHeight) - titleBarHeight)
                    }
                }
                .ignoresSafeArea(edges: .top)
            }
    }

    private func headerImageView(in proxy: GeometryProxy) -> some View {
        Image(.profile)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: isExpanded ? proxy.size.width : imageMaxHeight,
                   height: isExpanded ? proxy.size.height / 1.5 : imageMaxHeight)
            .opacity(scaleDownImage)
            .blur(radius: 10 * (1 - scaleDownImage), opaque: true)
            .clipShape(.rect(cornerRadius: isExpanded ? 0 : imageMaxHeight / 2.0))
            .anchorPreference(key: AnchorKey.self, value: .bounds) {
                ["profileImage" : $0]
            }
            .scaleEffect(0.5 + scaleDownImage * 0.5, anchor: .bottom)
    }

    private func headerTextsView() -> some View {
        VStack {
            Text("Mark Spencer")
                .font(.title.bold())
                .foregroundStyle(isExpanded ? .darkBlue : .white)
                .frame(maxWidth: .infinity, alignment: isExpanded ? .leading : .center)

            Text("+71 666 666 666 · @maspen")
                .font(.title3.bold())
                .foregroundStyle(isExpanded ? .darkBlue : .gray)
                .frame(maxWidth: .infinity, alignment: isExpanded ? .leading : .center)
        }
        .padding(.vertical, 10)
        .padding(.leading, isExpanded ? 20 : 0)
        .background(.ultraThinMaterial.opacity(isExpanded ? 0.6 : 0))
   }

    private func titleView(in proxy: GeometryProxy) -> some View {
        Rectangle()
            .fill(.lightBlue)
            .shadow(radius: 4)
            .frame(height: proxy.safeAreaInsets.top + barHeight)
            .overlay(alignment: .bottom) {
                Text("Mark Spencer")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .padding(.bottom)
                    .opacity(min(max(-offset - maxOffsetThreshold * 4, 0.0), maxOffsetThreshold) / maxOffsetThreshold)
           }
    }

    private func backgroundCanvasView(safeArea: EdgeInsets, anchors: [AnyHashable :Anchor<CGRect>]) -> some View {
        GeometryReader { geo in
            if let anchor = anchors["profileImage"],
               safeArea.bottom > 0, horizontalSizeClass == .compact, !isExpanded {
                let imageRect = geo[anchor]

                // Calculations are susceptible to errors, since there is no way to determine whether or not the iPhone has a Dynamic Island or notch, nor their dimensions.
                //New models with different features may cause the effect to not work well.

                let dynamicIslandiPhone = safeArea.top > 51
                let capsuleWidth = dynamicIslandiPhone ? 128.0 : 150.0
                let capsuleHeight = 32.0
                let capsuleY = dynamicIslandiPhone ? 15.0 : 0

                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.5))
                    context.addFilter(.blur(radius: 12))

                    context.drawLayer { ctx in
                        if let symbol = context.resolveSymbol(id: 1) {
                            ctx.draw(symbol, in: CGRect(origin: .init(x: size.width / 2 - capsuleWidth / 2, y: capsuleY),
                                                        size: CGSize(width: capsuleWidth, height: capsuleHeight)))
                        }

                        if let symbol = context.resolveSymbol(id: 2) {
                            ctx.draw(symbol, in: imageRect)
                        }
                    }
                } symbols: {
                    Capsule()
                        .frame(width: capsuleWidth, height: capsuleHeight)
                        .tag(1)

                    Circle()
                        .frame(width: imageMaxHeight, height: imageMaxHeight)
                        .tag(2)
                }
            }
        }
    }

    private func viewAdjustments(_ value: CGFloat) {
        if (value > minOffsetThreshold && !isExpanded) || (value < -minOffsetThreshold && isExpanded) {
            isExpanded.toggle()
        } else {
            offset = value
            scaleDownImage = 1 - (min(max((-value - minOffsetThreshold), 0.0), maxOffsetThreshold) / maxOffsetThreshold)
            scaleUpHeader = isExpanded ?  1 + min(max(value / 500, 0), 1) : 1
        }
    }
}

#Preview {
    ProfileView()
}
