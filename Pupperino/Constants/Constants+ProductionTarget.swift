
import UIKit

extension Constants {
    
    struct Server {
        static let serverOperationTimeoutInterval: TimeInterval = 30 // seconds
        static let headerContentType = "application/x-www-form-urlencoded"
        
        static let serverScheme = "http"
        static let serverHost = "www.cvinfo.lt"
        static let serverCommonPathStart = "/api/v0/"
    }
}
