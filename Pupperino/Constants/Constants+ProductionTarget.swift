
import UIKit

extension Constants {
    
    struct Server {
        static let serverOperationTimeoutInterval: TimeInterval = 30 // seconds
        static let headerContentType = "application/x-www-form-urlencoded"
        
        static let serverScheme = "https"
        static let serverHost = "newsapi.org"
        static let serverCommonPathStart = "/v2/" // the way path part starts for all server operations
        
        static let newsApiKey = "7ae905f5915f483699e6e4c7f0651986"
    }
}
