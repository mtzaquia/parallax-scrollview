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

/// The model required by the ``ParallaxScrollView``'s `init`.
public struct ParallaxHeader<Header: View, Background: View> {
    let defaultHeight: CGFloat?
    let isCollapsed: Binding<Bool>?
    let header: Header
    let background: Background

    /// Creates a new ``ParallaxHeader``.
    /// 
    /// - Note: The `background` view is not interactive, and will ignore touches.
    /// - Important: The default height must not be smaller than the intrinsic size of the `header` view. Use `nil` to obtain a
    ///   non-expanding header.
    ///
    /// - Parameters:
    ///   - defaultHeight: The default height for the header, akin to an expanded height. If `nil`, the header size
    ///   is used, resulting in an ever-collapsed header.
    ///   - isCollapsed: A `Binding` that will be updated based on the current collapsed state of the view. Useful
    ///   for applying tweaks to the header and background based on their states.
    ///   - header: The header view builder. The size of this view determines the size of the collapsed state. This view
    ///   receives and handles touches normally.
    ///   - background: The background view builder. Its size is determined by the `defaultHeight`, and will adjust
    ///   as needed until the minimum, collapsed size during scroll. The background doesn't receive touches.
    public init(
        defaultHeight: CGFloat?,
        isCollapsed: Binding<Bool>? = nil,
        @ViewBuilder header: () -> Header,
        @ViewBuilder background: () -> Background
    ) {
        self.defaultHeight = defaultHeight
        self.isCollapsed = isCollapsed
        self.header = header()
        self.background = background()
    }
}
