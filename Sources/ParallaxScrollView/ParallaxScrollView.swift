//
//  Copyright (c) 2024 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI

// MARK: - Constants

enum Namespace {
    static let parallaxScrollView = "ParallaxScrollViewNamespace"
}

// MARK: - View

/// An extended version of `SwiftUI.ScrollView` with parallax header support.
public struct ParallaxScrollView<
    Header: View,
    Background: View,
    Content: View
>: View {
    private let showsIndicators: Bool
    private let parallaxHeader: ParallaxHeader<Header, Background>
    private let content: Content

    @State var offset = CGPoint()
    @State var minimumHeight: CGFloat = .zero

    public var body: some View {
        ZStack(alignment: .top) {
            headerBackground()

            ScrollView(showsIndicators: showsIndicators) {
                VStack(spacing: 0) {
                    offsetReader
                    header()
                    content
                }
            }
            .coordinateSpace(name: Namespace.parallaxScrollView)
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset = $0 }
        }
        .onAppear {
            parallaxHeader.isCollapsed?.wrappedValue = isCollapsed
        }
        .onChange(of: isCollapsed) { newValue in
            parallaxHeader.isCollapsed?.wrappedValue = newValue
        }
    }

    /// Creates a new ``ParallaxScrollView``.
    /// - Parameters:
    ///   - showsIndicators: A Boolean value that indicates whether the scroll
    ///     view displays the scrollable component of the content offset. Defaults to `true`.
    ///   - parallaxHeader: A builder providing a `ParallaxHeader` instance. This is not a view builder.
    ///   - content: A view builder for the regular content for the scroll view.
    public init(
        showsIndicators: Bool = true,
        parallaxHeader: () -> ParallaxHeader<Header, Background>,
        @ViewBuilder content: () -> Content
    ) {
        self.showsIndicators = showsIndicators
        self.parallaxHeader = parallaxHeader()
        self.content = content()
    }
}

private extension ParallaxScrollView {
    @ViewBuilder
    func header() -> some View {
        parallaxHeader.header
            .observeGeometry { if minimumHeight == .zero { minimumHeight = $0.size.height } }
            .frame(height: headerHeight, alignment: .bottom)
            .offset(y: headerOffset)
            .opacity(isCollapsed ? 0 : 1)
    }

    @ViewBuilder
    func headerBackground() -> some View {
        Group {
            Color.clear.background {
                parallaxHeader
                    .background
            }
            .clipped()
            .offset(y: headerBackgroundOffset)
            .ignoresSafeArea()
            .frame(height: headerBackgroundHeight)
            .allowsHitTesting(false)

            if isCollapsed {
                parallaxHeader
                    .header
                    .opacity(isCollapsed ? 1 : 0)
            }
        }
        .zIndex(isCollapsed ? 1 : 0)
    }
}

private extension ParallaxScrollView {
    @ViewBuilder
    var offsetReader: some View {
        Color.clear
            .observeGeometry(
                ScrollOffsetPreferenceKey.self,
                map: { $0.frame(in: .named(Namespace.parallaxScrollView)).origin }
            )
            .frame(height: 0)
    }

    var headerHeight: CGFloat? {
        expandedHeight + max(0, offset.y)
    }

    var headerBackgroundHeight: CGFloat? {
        guard let headerHeight else { return nil }
        return headerHeight + max(0, offset.y)
    }

    var headerBackgroundOffset: CGFloat {
        guard offset.y < 0 else { return 0 }
        let difference = -expandedHeight + minimumHeight
        return max(offset.y, difference)
    }

    var headerOffset: CGFloat {
        let difference = (-expandedHeight + minimumHeight)
        if offset.y < difference {
            return -offset.y + difference
        }

        return 0
    }

    var isCollapsed: Bool {
        if parallaxHeader.defaultHeight == nil {
            return headerBackgroundOffset >= offset.y
        } else {
            return headerBackgroundOffset > offset.y
        }
    }

    var expandedHeight: CGFloat {
        parallaxHeader.defaultHeight ?? minimumHeight
    }
}

func myHeader(isCollapsed: Bool) -> some View {
    HStack {
                        VStack(alignment: .leading) {
                            Text("Header")
                                .bold()
                            Text("Another")
                        }
                        .foregroundStyle(isCollapsed ? .green : .white)

                        Spacer()

                        SwiftUI.Button("Push me") {
                            print("tapped!")
                        }
                    }
                    .padding()
}

func myImage() -> Image {
    Image(systemName: "person")
}

func myScrollableContent() -> some View {
    Text("Content")
}

#Preview {
    Sample()
}

struct Sample: View {
    @State var isCollapsed = true

    var body: some View {
        ParallaxScrollView {
            ParallaxHeader(
                defaultHeight: 300,
                isCollapsed: $isCollapsed
            ) {
                myHeader(isCollapsed: isCollapsed)
                    .background {
                        LinearGradient(
                            colors: [
                                .clear,
                                .black.opacity(0.4),
                                .black
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
                    }
            } background: {
                // an example of an image that blurs when collapsed.
                myImage()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .animation(nil, value: isCollapsed)
                    .blur(radius: isCollapsed ? 3 : 0)
                    .animation(.snappy, value: isCollapsed)
            }
        } content: {
            myScrollableContent()
                .frame(height: 1000)
        }
    }
}
