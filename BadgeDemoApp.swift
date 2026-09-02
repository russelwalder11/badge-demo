import SwiftUI
import UIKit
import UserNotifications

// AppDelegate requests notification permission (including badge)
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if !granted {
                print("Notifications permission not granted. In‑app badge still works.")
            }
            if let e = error { print("Auth error:", e) }
        }
        return true
    }

    // Show banner while app is foreground (optional)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}

@main
struct BadgeDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/// Main view — shows the icon with overlay badge and buttons to simulate replies
struct ContentView: View {
    @State private var unreadCount: Int = 1

    var body: some View {
        VStack(spacing: 24) {
            // IconWithBadge will use your asset "connect_giant" if present, otherwise a system image
            IconWithBadge(image: loadIcon(), size: 120, count: unreadCount)

            Text("Unread count: \(unreadCount)")
                .font(.headline)

            HStack(spacing: 16) {
                Button(action: simulateReply) {
                    Text("Simulate Reply")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: clearUnread) {
                    Text("Clear")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }

            Spacer()
            Text("Note: This updates the in-app badge and the system app icon badge.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
        .onAppear { updateSystemBadge() }
    }

    private func simulateReply() {
        unreadCount += 1
        updateSystemBadge()
    }

    private func clearUnread() {
        unreadCount = 0
        updateSystemBadge()
    }

    private func updateSystemBadge() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = unreadCount
        }
    }

    private func loadIcon() -> Image {
        if let ui = UIImage(named: "connect_giant") {
            return Image(uiImage: ui)
        } else {
            return Image(systemName: "gearshape.fill")
        }
    }
}

/// Reusable SwiftUI icon + badge view (iOS-style red circular badge with white number)
struct IconWithBadge: View {
    let image: Image
    let size: CGFloat
    let count: Int

    var body: some View {
        ZStack(alignment: .topTrailing) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .cornerRadius(size * 0.18)

            if count > 0 {
                let text = count > 99 ? "99+" : "\(count)"
                Text(text)
                    .font(.system(size: max(10, size * 0.18), weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, text.count > 2 ? 6 : 4)
                    .frame(height: max(18, size * 0.22))
                    .background(Color(red: 1.0, green: 59/255, blue: 48/255)) // iOS badge red
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 1)
                    .offset(x: size * 0.18, y: -size * 0.12)
                    .accessibilityLabel("\(count) unread notifications")
            }
        }
    }
}
