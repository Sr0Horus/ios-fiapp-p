//
//  Util.swift
//  ios-fiapp
//
//  Created by Pipe Carrasco on 27-07-21.
//

import Foundation

final class Util {
    
    static func version() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "\(version)(\(build))"
        }
        return ""
    }
}
