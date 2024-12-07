import WidgetKit
import SwiftUI

struct EversendEntry: TimelineEntry {
  let date: Date
  let lastUpdated: String
}

struct DemoWidgetProvider: TimelineProvider {
  func placeholder(in context: Context) -> EversendEntry {
    EversendEntry(date: Date(), lastUpdated: "Just now")
  }

  func getSnapshot(in context: Context, completion: @escaping (EversendEntry) -> ()) {
    let userDefaults = UserDefaults(suiteName: "group.expo.modules.exposhareintent.example")

    let entry = EversendEntry(date: Date(), lastUpdated: userDefaults?.string(forKey: "lastUpdated") ?? "Just now")

    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let userDefaults = UserDefaults(suiteName: "group.expo.modules.exposhareintent.example")

    var entries: [EversendEntry] = []

    let entry = EversendEntry(date: Date(), lastUpdated: userDefaults?.string(forKey: "lastUpdated") ?? "Just now")

    entries.append(entry)

    let timeline = Timeline(entries: entries, policy: .atEnd)

    completion(timeline)
  }
}

extension WidgetConfiguration {
    func disableContentMarginsIfNeeded() -> some WidgetConfiguration {
        if #available(iOSApplicationExtension 17.0, *) {
            return self.contentMarginsDisabled()
        } else {
            return self
        }
    }
}

extension View {
  func widgetBackground() -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      return containerBackground(for: .widget) {
        ZStack {
          Color("backgroundColor")
          Image("background")
            .resizable()
            .scaledToFill()
        }
      }
    } else {
      return background {
        ZStack {
          Color("backgroundColor")
            .ignoresSafeArea()
          Image("background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        }
      }
    }
  }
}

struct EversendMediumWidgetEntryView: View {
  let entry: DemoWidgetProvider.Entry

  var body: some View {
    VStack(alignment: .leading) {
    }
      .padding(.top, 15)
      .widgetBackground()
  }
}

struct DemoWidgetEntryView : View {
  @Environment(\.widgetFamily) var widgetFamily
  
  let entry: DemoWidgetProvider.Entry

  var body: some View {
    switch widgetFamily {
      case .systemMedium:
        EversendMediumWidgetEntryView(entry: entry)
      default:
        EversendMediumWidgetEntryView(entry: entry)
    }
  }
}


struct widgets: Widget {
  let kind: String = "DemoWidget"

  var body: some WidgetConfiguration {
      StaticConfiguration(kind: kind, provider: DemoWidgetProvider()) { entry in
          DemoWidgetEntryView(entry: entry)
      }
        .configurationDisplayName("Demo Widget")
        .description("This widget displays nothing useful")
        .supportedFamilies([.systemMedium])
        .disableContentMarginsIfNeeded()
  }
}