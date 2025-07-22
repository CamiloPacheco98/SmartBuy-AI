import Foundation

enum Environment {
    static var baseURL: URL {
        guard let urlString = Bundle.main.infoDictionary?["BASE_URL"] as? String,
            let url = URL(string: urlString)
        else {
            fatalError("BASE_URL is missing or invalid in Info.plist")
        }
        debugPrint("baseURL: \(url)")
        return url
    }
}
