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
            return CategoryModel(image: "suitcase", value: "business", title: "Business")
        case .entertainment:
            return CategoryModel(image: "face.smiling", value: "entertainment", title: "Entertainment")
        case .general:
            return CategoryModel(image: "square", value: "general", title: "General")
        case .health:
            return CategoryModel(image: "heart.square", value: "health", title: "Health")
        case .science:
            return CategoryModel(image: "atom", value: "science", title: "Science")
        case .sports:
            return CategoryModel(image: "volleyball", value: "sports", title: "Sports")
        case .technology:
            return CategoryModel(image: "laptopcomputer", value: "technology", title: "Technology")
        }
    }
}
