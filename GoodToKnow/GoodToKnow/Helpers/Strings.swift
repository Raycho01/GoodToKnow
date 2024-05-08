//
//  Strings.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 8.05.24.
//

import Foundation

struct Strings {
    
    struct ScreenTitles {
        static let home = NSLocalizedString("home_title", comment: "Localizable")
        static let hotNews = NSLocalizedString("hot_news_title", comment: "Localizable")
        static let allNews = NSLocalizedString("all_news_title", comment: "Localizable")
        static let settings = NSLocalizedString("settings_title", comment: "Localizable")
    }
    
    struct SectionTitles {
        static let countries = NSLocalizedString("countires_title", comment: "Localizable")
        static let categories = NSLocalizedString("categories_title", comment: "Localizable")
    }
    
    struct Categories {
        static let business = NSLocalizedString("business_category", comment: "Localizable")
        static let entertainment = NSLocalizedString("entertainment_category", comment: "Localizable")
        static let general = NSLocalizedString("general_category", comment: "Localizable")
        static let health = NSLocalizedString("health_category", comment: "Localizable")
        static let science = NSLocalizedString("science_category", comment: "Localizable")
        static let sports = NSLocalizedString("sports_category", comment: "Localizable")
        static let technology = NSLocalizedString("technology_category", comment: "Localizable")
    }

    struct NewsDetails {
        static let originAuthor = NSLocalizedString("origin_author", comment: "Localizable")
        static let originSource = NSLocalizedString("origin_source", comment: "Localizable")
        static let originPublished = NSLocalizedString("origin_published", comment: "Localizable")
        static let unknownPlaceholder = NSLocalizedString("unknown_placeholder", comment: "Localizable")
    }
    
    struct Settings {
        static let darkMode = NSLocalizedString("dark_mode", comment: "Localizable")
        static let language = NSLocalizedString("language", comment: "Localizable")
        static let bulgarianLanguage = NSLocalizedString("bulgarian_language", comment: "Localizable")
        static let englishLanguage = NSLocalizedString("english_language", comment: "Localizable")
    }
    
    struct Alert {
        static let continueActionTitle = NSLocalizedString("continue", comment: "Localizable")
        static let cancelActionTitle = NSLocalizedString("cancel", comment: "Localizable")
        static let restartTitle = NSLocalizedString("restart_title", comment: "Localizable")
        static let restartSubtitle = NSLocalizedString("restart_subtitle", comment: "Localizable")
    }
}
