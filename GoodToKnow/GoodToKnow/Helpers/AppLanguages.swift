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
        if value == "bg" { // TODO: Refactor if there are more languages in the future
            self.display = Strings.Settings.bulgarianLanguage
        } else {
            self.display = Strings.Settings.englishLanguage
        }
    }
}

final class AppLanguages {
    private(set) static var languages: [Language] {
        get {
            return getCurrentLanguages()
        }
        set {}
    }
    
    static func swapLanguages() {
        var newLanguages = languages
        newLanguages.swapAt(0, 1)
        let stringLanguages = newLanguages.map { $0.value }
        UserDefaults.standard.set(stringLanguages, forKey: "AppleLanguages")
    }
    
    private static func getCurrentLanguages() -> [Language] {
        guard let currentLangsAsStrings = UserDefaults.standard.value(forKey: "AppleLanguages") as? [String] else { return [] }
        
        return currentLangsAsStrings.map { languageValue in
            Language(value: languageValue)
        }
    }
}
