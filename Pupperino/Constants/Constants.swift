
import UIKit

// swiftlint:disable nesting
struct Constants {
    struct Colors {
        static let badRed: UIColor = UIColor.red
    }
    
    struct Notifications {
        struct ArticleFavouriteStatusHasChanged {
            static let name = Notification.Name("articleFavouriteStatusHasChanged_name")
            static let articleUserInfoKey = "articleFavouriteStatusHasChanged_articleUserInfoKey"
        }
    }
    
    struct DateFormatters {
        struct Default {
            static let dateFormat = "yyyy-MM-dd HH:mm"
        }
        
        struct BackEndServer {
            static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        }
    }
}

enum ArticleFavouriteStatus {
    case favourite
    case notFavourite
    case favouriteStatusIsChanging
}
// swiftlint:enable nesting
