import Foundation

struct VersionInfo {
    static let version = "2.1.0"
    static let gitHash = "c6703ea771616ad2980a993916ba9ed07f08f567"
    static let buildDate = "2026-04-22"
    
    static var displayVersion: String {
        if gitHash != "dev-build" && gitHash != "unknown" && !gitHash.isEmpty {
            let shortHash = String(gitHash.prefix(7))
            return "\(version) (\(shortHash))"
        }
        return version
    }
    
    static var fullVersionInfo: String {
        var info = "Waybetter Desktop \(version)"
        if gitHash != "dev-build" && gitHash != "unknown" && !gitHash.isEmpty {
            let shortHash = String(gitHash.prefix(7))
            info += " • \(shortHash)"
        }
        if !buildDate.isEmpty {
            info += " • \(buildDate)"
        }
        return info
    }
}