//
//  WeatherIconCreator.swift
//
//
//  Created by Ulaş Sancak on 15.10.2023.
//

import Foundation

struct WeatherIconURLCreator {
    static func create(with code: String) -> String {
        Constants.Image.fullBaseIMGURL + "/" + code + "@2x.png"
    }
}
