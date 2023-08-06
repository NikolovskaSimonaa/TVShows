import Foundation

enum Constants {
    
    enum Storyboards {
        static let login = "Login"
        static let home = "Home"
        static let showDetails = "ShowDetails"
        static let writeReview = "WriteReview"
        static let profileDetails = "ProfileDetails"
    }
    enum ViewControllers {
        static let login = "LoginViewController"
        static let home = "HomeViewController"
        static let showDetails = "ShowDetailsViewController"
        static let writeReview = "WriteReviewViewController"
        static let profileDetails = "ProfileDetailsViewController"
        
    }
    enum ViewCells {
        static let imageDescription = "ImageDescriptionTableViewCell"
        static let rating = "RatingTableViewCell"
        static let noReviews = "NoReviewsTableViewCell"
        static let review = "ReviewTableViewCell"
        static let button = "ButtonTableViewCell"
        static let writeReview = "WriteReviewTableViewCell"
    }
    enum Strings {
        static let placeholder = "Enter your comment here..."
    }
    enum Defaults: String {
        case switchStateKey
        case rememberMeKey
    }
    
}

extension Notification.Name {
    static let didLogout  = Notification.Name("User did logout")
}
