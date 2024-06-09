//
//  AppLanguages.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 8.05.24.
//

import Foundation

struct Language: Hashable {
    let display: String
    let value: String
    
    init(value: String) {
        self.value = value
        
        switch value {
        case "bg-BG":
            self.display = Strings.Settings.bulgarianLanguage
        case "en-BG":
            self.display = Strings.Settings.englishLanguage
        default:
            self.display = "Unsupported"
        }
    }
}

final class AppLanguages {
    
    static func getCurrentLanguages() -> [Language] {
        let currentLangsAsStrings = Locale.preferredLanguages
        return currentLangsAsStrings.map { languageValue in
            Language(value: languageValue)
        }
    }
    
    static func selectLanguage(language: Language) {
        guard var currentLangsAsStrings = UserDefaults.standard.value(forKey: "AppleLanguages") as? [String],
              let selectedLanguageIndex = currentLangsAsStrings.firstIndex(where: { $0 == language.value })
        else { return }
        
        currentLangsAsStrings.swapAt(selectedLanguageIndex, 0)
    }
    
    static func selectLanguage(languageName: String) {
        
        guard let language = getCurrentLanguages().first(where: { $0.display == languageName }) else { return }
        
        guard var currentLangsAsStrings = UserDefaults.standard.value(forKey: "AppleLanguages") as? [String],
              let selectedLanguageIndex = currentLangsAsStrings.firstIndex(where: { $0 == language.value })
        else { return }
        
        currentLangsAsStrings.swapAt(selectedLanguageIndex, 0)
        UserDefaults.standard.set(currentLangsAsStrings, forKey: "AppleLanguages")
    }
}
