//
//  GeneralEmptyConfiguration.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 22.03.24.
//

import UIKit

struct GeneralEmptyConfiguration {
    
    static let shared: UIContentUnavailableConfiguration = {
        var config = UIContentUnavailableConfiguration.empty()
        config.image = UIImage(systemName: "doc.questionmark")
        config.imageProperties.tintColor?.withAlphaComponent(0.5)
        config.text = Strings.Alert.noArticlesTitle
        config.secondaryText = Strings.Alert.tryAgainSubtitle
        return config
    }()
}
