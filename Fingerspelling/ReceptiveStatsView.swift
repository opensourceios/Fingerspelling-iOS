import SwiftUI

struct ReceptiveStatsView: View {
  @EnvironmentObject var game: GameState
  @EnvironmentObject var settings: UserSettings

  init() {
    // Remove extra separators below the list
    UITableView.appearance().tableFooterView = UIView()
  }

  private var longestWord: String {
    self.game.receptiveCompletedWords.max(by: { $0.word.count < $1.word.count })?.word ?? ""
  }

  private var averageWordLength: Double {
    (self.game.receptiveCompletedWords.map { $0.word.count }).average
  }

  private var fastestSpeed: Double {
    self.game.receptiveCompletedWords.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
  }

  private var averageSpeed: Double {
    (self.game.receptiveCompletedWords.map { $0.speed }).average
  }

  var body: some View {
    NavigationView {
      List {
        StatItemWithIconView(
          iconName: "checkmark",
          label: "Words completed"
        ) {
          Text(String(self.game.receptiveScore))
        }
        StatItemWithIconView(
          iconName: "metronome",
          label: "Current speed"
        ) {
          Text(self.settings.speedDisplay)
        }

        if !self.game.receptiveCompletedWords.isEmpty {
          StatItemView(label: "Longest word") {
            Text(self.longestWord.uppercased())
              .font(.system(size: 18, design: .monospaced))
          }

          StatItemView(label: "Average word length") {
            Text(formatNumber(self.averageWordLength))
          }

          StatItemView(label: "Fastest speed") {
            Text(formatNumber(self.fastestSpeed))
          }

          StatItemView(label: "Average speed") {
            Text(formatNumber(self.averageSpeed))
          }
        }
      }
      .navigationBarTitle("Stats (Receptive)")
      .navigationBarItems(trailing: Button(action: self.handleToggle) { Text("Done") })
      .listRowInsets(nil)
    }
  }

  private func handleToggle() {
    self.game.toggleSheet(.receptiveStats)
  }
}

struct ReceptiveStatsView_Previews: PreviewProvider {
  static var previews: some View {
    let game = SystemServices.game
    game.receptiveCompletedWords = [
      CompletedWord("fly", speed: 3.0),
      CompletedWord("turkey", speed: 3.0),
      CompletedWord("heavy", speed: 4.0),
    ]
    return ReceptiveStatsView()
      .modifier(SystemServices())
  }
}
