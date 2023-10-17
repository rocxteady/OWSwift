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
        if identifier.hasPrefix("af") {
            return .af
        } else if identifier.hasPrefix("sq") {
            return .al
        } else if identifier.hasPrefix("ar_") || identifier == "ar" {
            return .ar
        } else if identifier.hasPrefix("az") {
            return .az
        } else if identifier.hasPrefix("bg_") || identifier == "bg" {
            return .bg
        } else if identifier.hasPrefix("ca") {
            return .ca
        } else if identifier.hasPrefix("cs") {
            return .cz
        } else if identifier.hasPrefix("da_") || identifier == "da" {
            return .da
        } else if identifier.hasPrefix("de") {
            return .de
        } else if identifier.hasPrefix("el") {
            return .el
        } else if identifier.hasPrefix("eu") {
            return .eu
        } else if identifier.hasPrefix("fa") {
            return .fa
        } else if identifier.hasPrefix("fi") {
            return .fi
        } else if identifier.hasPrefix("fr") {
            return .fr
        } else if identifier.hasPrefix("gl") {
            return .gl
        } else if identifier.hasPrefix("he"){
            return .he
        } else if identifier.hasPrefix("hi"){
            return .hi
        } else if identifier.hasPrefix("hr") {
            return .hr
        } else if identifier.hasPrefix("hu") {
            return .hu
        } else if identifier.hasPrefix("id") {
            return .id
        } else if identifier.hasPrefix("it") {
            return .it
        } else if identifier.hasPrefix("ja") {
            return .ja
        } else if identifier.hasPrefix("ko-") || identifier == "ko" {
            return .kr
        } else if identifier.hasPrefix("lv") {
            return .la
        } else if identifier.hasPrefix("lt") {
            return .lt
        } else if identifier.hasPrefix("mk") {
            return .mk
        } else if identifier.hasPrefix("nb") {
            return .no
        } else if identifier.hasPrefix("nl") {
            return .nl
        } else if identifier.hasPrefix("pl") {
            return .pl
        } else if identifier.hasPrefix("pt_BR") {
            return .pt_br
        } else if identifier.hasPrefix("pt") {
            return .pt
        } else if identifier.hasPrefix("ro-") || identifier == "ro" {
            return .ro
        } else if identifier.hasPrefix("ru") {
            return .ru
        } else if identifier.hasPrefix("sv") {
            return .sv
        } else if identifier.hasPrefix("sk") {
            return .sk
        } else if identifier.hasPrefix("sl") {
            return .sl
        } else if identifier.hasPrefix("es") {
            return .es
        } else if identifier.hasPrefix("sr") {
            return .sr
        } else if identifier.hasPrefix("th") {
            return .th
        } else if identifier.hasPrefix("se") {
            return .sv
        } else if identifier.hasPrefix("tr-") || identifier == "tr" {
            return .tr
        } else if identifier.hasPrefix("uk") {
            return .uk
        } else if identifier.hasPrefix("vi") {
            return .vi
        } else if identifier.starts(with: "zh_Hant") {
            return .zh_tw
        } else if identifier.starts(with: "zh") {
            return .zh_cn
        } else if identifier.starts(with: "zu") {
            return .zu
        }
        return .en
    }
}
