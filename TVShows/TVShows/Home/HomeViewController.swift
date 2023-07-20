import UIKit
final class HomeViewController:UIViewController {
    var userResponse: UserResponse?
    var authInfo: String?
    
    func setUserResponse(_ response: UserResponse){
        userResponse = response
    }
    
}
