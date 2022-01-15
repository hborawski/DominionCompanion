//
//  ShareSheet.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 1/15/22.
//  Copyright © 2022 Harris Borawski. All rights reserved.
//

import SwiftUI
import LinkPresentation

struct ShareSheet: UIViewControllerRepresentable {
    let item: UIActivityItemSource

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}


    func makeUIViewController(context: Context) -> some UIViewController {
        let activityController = UIActivityViewController(activityItems: [item], applicationActivities: [])
        return activityController
    }
}

class SharableItem: NSObject, UIActivityItemSource {
    let image: UIImage
    let title: String
    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }

    lazy var metaData: LPLinkMetadata = {
        let metadata = LPLinkMetadata()
        metadata.title = title
        return metadata
    }()

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage(named: "AppIcon") as Any
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        guard let type = activityType else { return nil }
        switch type {
        case .airDrop, .copyToPasteboard, .saveToCameraRoll:
            return image
        default: return nil
        }
    }

    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivity.ActivityType?, suggestedSize size: CGSize) -> UIImage? {
        return image
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return metaData
    }
}

struct ShareSheet_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheet(item: SharableItem(image: UIImage(), title: "Share Set"))
    }
}
