//
//  AlertPopupAction.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 21.03.24.
//

public struct AlertPopupAction {
    public let title: String
    public let isPreferred: Bool
    public let style: Int
    public let action: (() -> Void)?
    
    /// AlertPopupAction
    /// - parameter title: text to display for the action
    /// - parameter isPreferred: whether this action is highlighted to give it emphasis
    /// - parameter action: a callback that gets called when the action is executed
    public init(title: String, isPreferred: Bool = false, style: Int = 0, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
        self.style = style
        self.isPreferred = isPreferred
    }
}
