//
//  NSNotificationExtension.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 30.04.24.
//

import Foundation

extension NSNotification.Name {
    static let searchFiltersDidChange = NSNotification.Name(Bundle.main.bundleIdentifier! + ".searchFilters")
}
