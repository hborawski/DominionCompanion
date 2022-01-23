import SwiftUI

protocol GameplaySetupStyle {
    associatedtype Body: View
    func makeBody(_ configuration: Configuration) -> Body
    typealias Configuration = GameplaySetupConfiguration
}

struct GameplaySetupConfiguration {
    let model: SetModel
}

struct AnyGameplaySetupStyle: GameplaySetupStyle {
    private let _makeBody: (Configuration) -> AnyView

    public init<Style>(_ style: Style) where Style: GameplaySetupStyle {
        _makeBody = { AnyView(style.makeBody($0)) }
    }

    func makeBody(_ configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

struct GameplaySetupStyleKey: EnvironmentKey {
    static var defaultValue: AnyGameplaySetupStyle { GameplaySetupListStyle().eraseToAnyGameplaySetupStyle() }
}

extension EnvironmentValues {
    var gameplaySetupStyle: AnyGameplaySetupStyle {
        get { self[GameplaySetupStyleKey.self] }
        set { self[GameplaySetupStyleKey.self] = newValue }
    }
}

extension GameplaySetupStyle {
    func eraseToAnyGameplaySetupStyle() -> AnyGameplaySetupStyle {
        AnyGameplaySetupStyle(self)
    }
}

enum GameplaySetupStyles: String, CaseIterable {
    case list
    case pages
    case grid
}

extension GameplaySetupStyles {
    var style: AnyGameplaySetupStyle {
        switch self {
        case .list: return GameplaySetupListStyle().eraseToAnyGameplaySetupStyle()
        case .pages: return GameplaySetupPageStyle().eraseToAnyGameplaySetupStyle()
        case .grid: return GameplaySetupGridStyle().eraseToAnyGameplaySetupStyle()
        }
    }
}

struct GameplaySetupListStyle: GameplaySetupStyle {
    func makeBody(_ configuration: Configuration) -> some View {
        GameplaySetupList(model: configuration.model)
    }

    struct GameplaySetupList: View {
        @EnvironmentObject var cardData: CardData
        @AppStorage(Constants.SaveKeys.settingsGameplaySortMode) var sortMode: SortMode = .cost

        let model: SetModel
        var body: some View {
            List {
                if model.cards.contains(where: {$0.name == "Black Market"}) {
                    NavigationLink(destination: BlackMarketSimulatorView(cards: model.cards, data: cardData)) {
                        Text("Black Market Simulator")
                    }
                }
                cardSection("In Supply", model.cards)
                if model.notInSupply.count > 0 {
                    cardSection("Not In Supply", model.notInSupply)
                }
                if model.landmarks.count > 0 {
                    cardSection("Landmarks", model.landmarks)
                }
                if model.events.count > 0 {
                    cardSection("Events", model.events)
                }
                if model.projects.count > 0 {
                    cardSection("Projects", model.projects)
                }
                if model.ways.count > 0 {
                    cardSection("Ways", model.ways)
                }
                if model.getTokens().count > 0 {
                    Section(header: Text("Tokens")) {
                        ForEach(model.getTokens(), id: \.self) { Text($0) }
                    }
                }
                if model.getAdditionalMechanics().count > 0 {
                    Section(header: Text("Additional Mechanics")) {
                        ForEach(model.getAdditionalMechanics(), id: \.self) { Text($0) }
                    }
                }
                if model.shelters || model.colonies {
                    Section(header: Text("Victory and Treasure")) {
                        if model.shelters {
                            Text("Shelters")
                        }
                        if model.colonies {
                            ForEach(cardData.allCards.filter({ ["Colony", "Platinum"].contains($0.name)}), id: \.name) { card in
                                CardRow(card: card) { Text(card.expansion).foregroundColor(.gray) }.listRowInsets(EdgeInsets())
                            }
                        }
                    }
                }
            }.listStyle(InsetGroupedListStyle())
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

struct GameplaySetupPageStyle: GameplaySetupStyle {
    func makeBody(_ configuration: Configuration) -> some View {
        GameplaySetupPages(model: configuration.model)
    }

    struct GameplaySetupPages: View {
        @AppStorage(Constants.SaveKeys.settingsGameplaySortMode) var sortMode: SortMode = .cost

        let model: SetModel

        var body: some View {
            TabView {
                ForEach(model.events.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
                ForEach(model.landmarks.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
                ForEach(model.projects.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
                ForEach(model.ways.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
                ForEach(model.cards.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
                ForEach(model.notInSupply.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
            }
            .tabViewStyle(PageTabViewStyle())
        }

        func cardImage(_ card: Card) -> some View {
            VStack {
                HStack {
                    Image(systemName: "cube.box")
                    Text(card.expansion)
                }
                Image(uiImage: card.image ?? UIImage())
                    .resizable()
                    .cornerRadius(8)
                    .padding(.horizontal, 24)
                    .aspectRatio(contentMode: .fit)
            }
            .padding(.bottom, 40)
        }
    }
}

struct GameplaySetupGridStyle: GameplaySetupStyle {
    func makeBody(_ configuration: Configuration) -> some View {
        GameplaySetupGrid(model: configuration.model)
    }

    struct GameplaySetupGrid: View {
        @AppStorage(Constants.SaveKeys.settingsGameplaySortMode) var sortMode: SortMode = .cost

        let model: SetModel

        var body: some View {
            ScrollView {
                VStack {
                    ForEach(model.events.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
                    ForEach(model.landmarks.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
                    ForEach(model.projects.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
                    ForEach(model.ways.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
                }
                LazyVGrid(columns: .halfSizeCard) {
                    ForEach(model.cards.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
                }
                Text("Not In Supply").font(.title2)
                LazyVGrid(columns: .halfSizeCard) {
                    ForEach(model.notInSupply.sorted(by: sortMode.sortFunction()), id: \.id) { cardImage($0) }
                }
            }
        }

        func cardImage(_ card: Card) -> some View {
            Image(uiImage: card.image ?? UIImage())
                .resizable()
                .cornerRadius(4)
                .aspectRatio(contentMode: .fit)
        }
    }
}
