//
//  FeedViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 21.05.24.
//

import Foundation
import UIKit
import VerticalCardSwiper

class FeedViewController: UIViewController {
    
    private var cardSwiper: VerticalCardSwiper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        cardSwiper = VerticalCardSwiper(frame: self.view.bounds)
        cardSwiper.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        cardSwiper.datasource = self
        cardSwiper.isStackingEnabled = false
        
        view.addSubview(cardSwiper)
        cardSwiper.fillSuperview(padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        cardSwiper.centerInSuperview()
    }
    

}

extension FeedViewController: VerticalCardSwiperDatasource {
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        if let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: index) as? FeedCell {
            cell.configure(with: NewsArticle(source: .init(id: "123", name: "ABC news"), author: "ABC news", title: "New Chat GPT 4o is crazy", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", url: "", urlToImage: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vandelaydesign.com%2Fcool-logos%2F&psig=AOvVaw2MVGJpYA6RKNjUgejIJ-6P&ust=1716386435728000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCKjM4_HznoYDFQAAAAAdAAAAABAE", publishedAt: .now, content: ""))
            return cell
        }
        return CardCell()
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return 4
    }
}
