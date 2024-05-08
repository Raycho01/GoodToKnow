//
//  CategoryModel.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 30.04.24.
//

import Foundation

struct CategoryModel {
    let image: String
    let value: String
    let title: String
}

enum Category {
    
    case business, entertainment, general, health, science, sports, technology
    
    func getModel() -> CategoryModel {
        switch self {
        case .business:
            return CategoryModel(image: "suitcase", value: "business", title: Strings.Categories.business)
        case .entertainment:
            return CategoryModel(image: "face.smiling", value: "entertainment", title: Strings.Categories.entertainment)
        case .general:
            return CategoryModel(image: "square", value: "general", title: Strings.Categories.general)
        case .health:
            return CategoryModel(image: "heart.square", value: "health", title: Strings.Categories.health)
        case .science:
            return CategoryModel(image: "atom", value: "science", title: Strings.Categories.science)
        case .sports:
            return CategoryModel(image: "volleyball", value: "sports", title: Strings.Categories.sports)
        case .technology:
            return CategoryModel(image: "laptopcomputer", value: "technology", title: Strings.Categories.technology)
        }
    }
}
