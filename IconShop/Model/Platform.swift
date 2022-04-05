//
//  Platform.swift
//  IconShop
//
//  Created by Billow on 2022/4/5.
//

import Foundation

// MARK: Platform
enum Platform: Int, CustomStringConvertible {
    case iOS
    case iPadOS
    case macOS
    
    var description: String {
        switch self {
        case .iOS:
            return "iOS"
        case .iPadOS:
            return "iPadOS"
        case .macOS:
            return "macOS"
        }
    }
    
    var software: String {
        switch self {
        case .iOS:
            return "software"
        case .iPadOS:
            return "iPadSoftware"
        case .macOS:
            return "macSoftware"
        }
    }
}
