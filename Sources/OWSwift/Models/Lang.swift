//
//  Lang.swift
//
//
//  Created by Ulaş Sancak on 14.10.2023.
//

import Foundation

enum Lang: String {
    case af      // Afrikaans
    case al      // Albanian
    case ar      // Arabic
    case az      // Azerbaijani
    case bg      // Bulgarian
    case ca      // Catalan
    case cz      // Czech
    case da      // Danish
    case de      // German
    case el      // Greek
    case en      // English
    case eu      // Basque
    case fa      // Persian (Farsi)
    case fi      // Finnish
    case fr      // French
    case gl      // Galician
    case he      // Hebrew
    case hi      // Hindi
    case hr      // Croatian
    case hu      // Hungarian
    case id      // Indonesian
    case it      // Italian
    case ja      // Japanese
    case kr      // Korean
    case la      // Latvian
    case lt      // Lithuanian
    case mk      // Macedonian
    case no      // Norwegian
    case nl      // Dutch
    case pl      // Polish
    case pt      // Portuguese
    case pt_br   // Português Brasil
    case ro      // Romanian
    case ru      // Russian
    case sv      // Swedish
    case sk      // Slovak
    case sl      // Slovenian
    case es      // Also Spanish
    case sr      // Serbian
    case th      // Thai
    case tr      // Turkish
    case uk      // Also Ukrainian
    case vi      // Vietnamese
    case zh_cn   // Chinese Simplified
    case zh_tw   // Chinese Traditional
    case zu      // Zulu
}

extension Locale {
    var lang: Lang? {
        let identifier = language.minimalIdentifier
        if identifier.hasPrefix("af") {
            return .af
        } else if identifier.hasPrefix("sq") {
            return .al
        } else if identifier.hasPrefix("ar-") || identifier == "ar" {
            return .ar
        } else if identifier.hasPrefix("az") {
            return .az
        } else if identifier == "bg" {
            return .bg
        } else if identifier.hasPrefix("ca") {
            return .ca
        } else if identifier == "cs" {
            return .cz
        } else if identifier.hasPrefix("da-") || identifier == "da" {
            return .da
        } else if identifier.hasPrefix("de") {
            return .de
        } else if identifier.hasPrefix("el") {
            return .el
        } else if identifier == "eu" {
            return .eu
        } else if identifier.hasPrefix("fa") {
            return .fa
        } else if identifier == "fi" {
            return .fi
        } else if identifier.hasPrefix("fr") {
            return .fr
        } else if identifier == "gl" {
            return .gl
        } else if identifier == "he" {
            return .he
        } else if identifier == "hi" {
            return .hi
        } else if identifier.hasPrefix("hr") {
            return .hr
        } else if identifier == "hu" {
            return .hu
        } else if identifier == "id" {
            return .id
        } else if identifier.hasPrefix("it") {
            return .it
        } else if identifier == "ja" {
            return .ja
        } else if identifier.hasPrefix("ko-") || identifier == "ko" {
            return .kr
        } else if identifier == "lv" {
            return .la
        } else if identifier == "lt" {
            return .lt
        } else if identifier == "mk" {
            return .mk
        } else if identifier.hasPrefix("nb") {
            return .no
        } else if identifier.hasPrefix("nl") {
            return .nl
        } else if identifier == "pl" {
            return .pl
        } else if identifier.hasPrefix("pt") {
            if language.region?.identifier == "BR" {
                return .pt_br
            }
            return .pt
        } else if identifier.hasPrefix("ro-") || identifier == "ro" {
            return .ro
        } else if identifier.hasPrefix("ru") {
            return .ru
        } else if identifier.hasPrefix("sv") {
            return .sv
        } else if identifier == "sk" {
            return .sk
        } else if identifier == "sl" {
            return .sl
        } else if identifier.hasPrefix("es") {
            return .es
        } else if identifier.hasPrefix("sr") {
            return .sr
        } else if identifier == "th" {
            return .th
        } else if identifier.hasPrefix("se") {
            return .sv
        } else if identifier.hasPrefix("tr-") || identifier == "tr" {
            return .tr
        } else if identifier == "uk" {
            return .uk
        } else if identifier == "vi" {
            return .vi
        } else if identifier.starts(with: "zh") {
            switch identifier {
            case "zh-Hant-JP",
                "zh-Hant-CN",
                "zh-TW",
                "zh-HK",
                "zh-MO":
                return .zh_tw
            default:
                return .zh_cn
            }
        } else if identifier == "zu" {
            return .zu
        }
        return .en
    }
}
