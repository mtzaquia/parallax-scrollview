# ParallaxScrollView

An extended `SwiftUI.ScrollView` with support for a sticky header that collapses to a compact size during scroll.

## Instalation

`ParallaxScrollView` is available via Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/mtzaquia/parallax-scrollview.git", from: "1.0.2"),
],
```

## Usage

Use `ParallaxScrollView` like a regular, vertical scroll view. The main difference is the `header` parameter. 

```swift
@State var isCollapsed = false

/* ... */

ParallaxScrollView {
  ParallaxHeader(defaultHeight: 300) { // an arbitrary, expanded height, or `nil`.
    // an example of a header with a gradient for sufficient contrast with the background image.
    myHeader()
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
        .ignoresSafeArea() // safe area applies when collapsed.
      }
  } background: {
    // an example of an image that blurs when collapsed.
    myImage()
      .resizable()
      .aspectRatio(contentMode: .fill)
      .animation(nil, value: isCollapsed) // avoids unwanted frame animation during scroll.
      .blur(radius: isCollapsed ? 3 : 0)
      .animation(.snappy, value: isCollapsed)
  }
} content: {
  myScrollableContent()
} onCollapsedChanged: { // optional callback to observe collapse state changes to tweak header/background design accordingly.
  isCollapsed = $0 
}
```

## Acknowledgements

- Thanks to [@chrisjrex](https://github.com/chrisjrex) for rubber ducking on a nearly daily basis.
- Thanks to [@danielsaidi](https://github.com/danielsaidi)'s [ScrollKit](https://github.com/danielsaidi/ScrollKit) for inspiration on offset tracking using `PreferenceKey`.

## License

Copyright (c) 2024 @mtzaquia

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
