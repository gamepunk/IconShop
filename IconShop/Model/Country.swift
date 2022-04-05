//
//  Country.swift
//  IconShop
//
//  Created by Billow on 2022/4/5.
//

import Foundation

enum Country: Int, CustomStringConvertible {
    case china
    case usa
    case japan
    
    var description: String {
        switch self {
        case .china:
            return "cn"
        case .usa:
            return "us"
        case .japan:
            return "jp"
        }
    }
}
