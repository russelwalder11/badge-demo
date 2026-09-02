# badge-demo

Simple demo showing an app icon with an iOS-style red notification badge and system app-icon badge sync.

How to run

1. Clone the repo:

   git clone https://github.com/russelwalder11/badge-demo.git

2. Open Xcode and create a new SwiftUI App project (or open an existing SwiftUI project). Copy the file `BadgeDemoApp.swift` into your Xcode project (File → Add Files).

3. Optionally add the SVG `connect_giant_with_badge.svg` into Assets.xcassets as `connect_giant` (Xcode can import SVGs) or add a PNG image named `connect_giant`.

4. Build & Run in Simulator or on a device. Use the "Simulate Reply" and "Clear" buttons to test the badge.

Notes
- The app requests notification permission but the in-app badge works regardless of permission. To have remote push set the app icon badge, configure APNs on your server and send `aps.badge` in the payload.
