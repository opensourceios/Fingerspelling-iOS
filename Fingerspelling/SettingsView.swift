import SwiftUI

struct SettingsView: View {
  @State var isShowingFeedbackAlert = false
  @EnvironmentObject private var settings: UserSettings
  @EnvironmentObject private var game: GameState
  @EnvironmentObject private var playback: PlaybackService

  static let wordLengths = Array(3 ... 8) + [Int.max]
  static let appId = "id1503242863"

  struct LabeledPicker<SelectionValue: Hashable, Content: View>: View {
    var selection: Binding<SelectionValue>
    var label: String
    var content: () -> Content

    var body: some View {
      Section(header: Text(self.label.uppercased())) {
        Picker(selection: self.selection, label: Text(self.label)) {
          self.content()
        }.pickerStyle(SegmentedPickerStyle())
      }
    }
  }

  var body: some View {
    NavigationView {
      Form {
        LabeledPicker(selection: self.$settings.maxWordLength, label: "Max Word Length (Letters)") {
          ForEach(Self.wordLengths, id: \.self) {
            Text($0 == Int.max ? "Any" : String($0)).tag($0)
          }
        }

        Section {
          Toggle(isOn: self.$settings.enableHaptics) {
            Text("Enable Haptics")
          }
        }

        Section {
          NavigationLink(destination: FeedbackView()) {
            Text("Send Feedback").fontWeight(.semibold)
          }
          Button(action: self.handleRate) {
            HStack {
              Text("Rate Fingerspelling").foregroundColor(.primary)
              Spacer()
              Image(systemName: "arrow.up.right").foregroundColor(.gray)
            }
          }
          NavigationLink(destination: AboutView()) { Text("About") }
        }
      }
      .navigationBarTitle("Settings")
      .navigationBarItems(trailing: Button(action: self.handleToggleSettings) { Text("Done") })
    }
  }

  private func handleToggleSettings() {
    self.game.toggleSheet(.settings)
    self.playback.stop()
  }

  private func handleRate() {
    if let url = URL(string: "https://itunes.apple.com/us/app/appName/\(Self.appId)?mt=8&action=write-review"),
      UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView().modifier(SystemServices())
  }
}
