//
//  CustomNavigationBarStyle.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 1/3/26.
//

import SwiftUI

// MARK: Custom Navigation Titles
enum CustomNavigationBarStyle {
    static func applyDefault() {
        let largeTitleFont = UIFont(
            name: "Avenir-Heavy",
            size: CustomFontSize.largeTitle.rawValue
        ) ?? .systemFont(ofSize: CustomFontSize.largeTitle.rawValue)
        let titleFont = UIFont(
            name: "Avenir-Heavy",
            size: CustomFontSize.subtitle.rawValue
        ) ?? .systemFont(ofSize: CustomFontSize.subtitle.rawValue)

        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: largeTitleFont,
            .foregroundColor: UIColor.black
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
    }
    
    static func applySecondaryTitleFont() {
        let mediumTitleFont = UIFont(
            name: "Avenir-Heavy",
            size: CustomFontSize.mediumTitle.rawValue
        ) ?? .systemFont(ofSize: CustomFontSize.mediumTitle.rawValue)
        let titleFont = UIFont(
            name: "Avenir-Heavy",
            size: CustomFontSize.subtitle.rawValue
        ) ?? .systemFont(ofSize: CustomFontSize.subtitle.rawValue)

        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: mediumTitleFont,
            .foregroundColor: UIColor.black
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
    }
}
