import SwiftUI

protocol SetBuilderStyle {
    associatedtype Body: View
    func makeBody(_ configuration: Configuration) -> Body
    typealias Configuration = SetBuilderConfiguration
}

struct SetBuilderConfiguration {
}

struct AnySetBuilderStyle: SetBuilderStyle {
    private let _makeBody: (Configuration) -> AnyView

    public init<Style>(_ style: Style) where Style: SetBuilderStyle {
        _makeBody = { AnyView(style.makeBody($0)) }
    }

    func makeBody(_ configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

struct SetBuilderStyleKey: EnvironmentKey {
    static var defaultValue: AnySetBuilderStyle { SetBuilderListStyle().eraseToAnySetBuilderStyle() }
}

extension EnvironmentValues {
    var setBuilderStyle: AnySetBuilderStyle {
        get { self[SetBuilderStyleKey.self] }
        set { self[SetBuilderStyleKey.self] = newValue }
    }
}

extension SetBuilderStyle {
    func eraseToAnySetBuilderStyle() -> AnySetBuilderStyle {
        AnySetBuilderStyle(self)
    }
}

enum SetBuilderStyles: String, CaseIterable {
    case list
    case pages
    case grid
}

extension SetBuilderStyles {
    var style: AnySetBuilderStyle {
        switch self {
        case .list: return SetBuilderListStyle().eraseToAnySetBuilderStyle()
        case .pages: return SetBuilderPageStyle().eraseToAnySetBuilderStyle()
        case .grid: return SetBuilderGridStyle().eraseToAnySetBuilderStyle()
        }
    }
}

struct SetBuilderListStyle: SetBuilderStyle {
    func makeBody(_ configuration: Configuration) -> some View {
        SetBuilderList()
    }

    struct SetBuilderList: View {
        @EnvironmentObject var setBuilder: SetBuilderModel
        @AppStorage(Constants.SaveKeys.settingsSortMode) var sortMode: SortMode = .cost
        @AppStorage(Constants.SaveKeys.settingsShowExpansionsWhenBuilding) var showExpansion: Bool = false

        var body: some View {
            List {
                Section(header: Text("Landscape Cards")) {
                    ForEach(setBuilder.landscape, id: \.name) { card in
                        NavigationCardRow(card: card, showExpansion: self.showExpansion)
                    }
                }
                Section(header: Text("Cards")) {
                    ForEach(setBuilder.cards.sorted(by: sortMode.sortFunction()), id: \.name) { card in
                        NavigationCardRow(card: card, showExpansion: self.showExpansion)
                    }
                }
            }.listStyle(GroupedListStyle())
        }

        func cardSection(_ title: String, _ cards: [Card]) -> some View {
            return Section(header: Text(title)) {
                ForEach(cards.sorted(by: sortMode.sortFunction()), id: \.name) { card in
                    CardRow(card: card) { Text(card.expansion).foregroundColor(.gray) }.listRowInsets(EdgeInsets())
                }
            }
        }
    }
}

struct SetBuilderPageStyle: SetBuilderStyle {
    func makeBody(_ configuration: Configuration) -> some View {
        SetBuilderPages()
    }

    struct SetBuilderPages: View {
        @EnvironmentObject var setBuilder: SetBuilderModel
        @AppStorage(Constants.SaveKeys.settingsSortMode) var sortMode: SortMode = .cost
        @AppStorage(Constants.SaveKeys.settingsShowExpansionsWhenBuilding) var showExpansion: Bool = false

        var body: some View {
            TabView {
                ForEach(setBuilder.landscape.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
                ForEach(setBuilder.cards.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
            }
            .tabViewStyle(PageTabViewStyle())
        }

        func cardImage(_ card: Card) -> some View {
            NavigationCardImage(card: card, showExpansion: showExpansion)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .padding(.top, 8)
        }
    }
}

struct SetBuilderGridStyle: SetBuilderStyle {
    func makeBody(_ configuration: Configuration) -> some View {
        SetBuilderGrid()
    }

    struct SetBuilderGrid: View {
        @EnvironmentObject var setBuilder: SetBuilderModel
        @AppStorage(Constants.SaveKeys.settingsSortMode) var sortMode: SortMode = .cost
        @AppStorage(Constants.SaveKeys.settingsShowExpansionsWhenBuilding) var showExpansion: Bool = false

        var body: some View {
            ScrollView {
                VStack {
                    ForEach(setBuilder.landscape.sorted(by: sortMode.sortFunction()), id: \.id) {
                        NavigationCardImage(card: $0, showExpansion: showExpansion)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)
                LazyVGrid(columns: .halfSizeCard) {
                    ForEach(setBuilder.cards.sorted(by: sortMode.sortFunction()), id: \.id) {
                        NavigationCardImage(card: $0, showExpansion: showExpansion)
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }
}

struct NavigationCardImage: View {
    let card: Card
    let showExpansion: Bool
    var body: some View {
        VStack {
            PinnableCard(card: card)
            VStack {
                if showExpansion {
                    HStack {
                        Image(systemName: "cube.box")
                        Text(card.expansion)
                    }
                }
                LargePinButton(card: card)
            }
        }
    }
}

struct PinnableCard: View {
    @EnvironmentObject var setBuilder: SetBuilderModel
    let card: Card

    var pinned: Bool {
        setBuilder.pinnedLandscape.contains(card) || setBuilder.pinnedCards.contains(card)
    }

    var body: some View {
        NavigationLink(destination: CardView(card: card, accessory: { PinButton(card: $0) })) {
            Image(uiImage: card.image ?? UIImage())
                .resizable()
                .cornerRadius(4)
                .aspectRatio(contentMode: .fit)
                .when(pinned) {
                    $0.overlay(RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 3).foregroundColor(.blue))
                }
        }
    }
}

extension Array where Element == GridItem {
    static var halfSizeCard = [GridItem(.adaptive(minimum: 145), spacing: 8, alignment: .center)]
}
