import UIKit

class ProfileDetailsViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var logoutButton: UIButton!
    
    //MARK: - Properties
    
    var user: User?
    var authInfo: AuthInfo?
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUIlogic()
    }
    
    //MARK: - Utility methods

    private func setupUIlogic(){
        logoutButton.layer.cornerRadius = 25
        logoutButton.clipsToBounds = true
        emailLabel.text = user?.email ?? "User not found"
    }
    
    private func setupNavigationBar() {
        title = "My Account"
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonClicked))
        closeButton.tintColor = UIColor(red: 82.0/255.0, green: 54.0/255.0, blue: 140.0/255.0, alpha: 1)
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    //MARK: - Actions
    
    @IBAction private func logoutButtonClicked() {
        dismiss(animated: true) {
            UserDefaults.standard.removeObject(forKey: Constants.Defaults.switchStateKey.rawValue)
            UserDefaults.standard.removeObject(forKey: Constants.Defaults.rememberMeKey.rawValue)
            NotificationCenter.default.post(name: .didLogout, object: nil)
        }
    }
    
}
