import Alamofire
import MBProgressHUD
import UIKit

final class LoginViewController:UIViewController {
    //MARK: - Outlets

    @IBOutlet private var seePasswordButton: UIButton!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var registerButton: UIButton!
    @IBOutlet private var rememberMeButton: UIButton!
    
    //MARK: - Properties
    
    private let attributesForTextField: [NSAttributedString.Key: Any] = [
        .foregroundColor : UIColor.white.withAlphaComponent(0.7),
        .font : UIFont.systemFont(ofSize: 17)
    ]
    private var userResponse: UserResponse?
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setUILogic()
        seePasswordButtonSetIcon()
        rememberMeButtonSetIcon()
        setTextFieldsAttributes()
        let rememberMeState = loadState()
        rememberMeButton.isSelected = rememberMeState
    }
    
    //MARK: - Utility methods
    
    @objc func editingChanged(_ textField: UITextField) {
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .lightText
            return
        }
        loginButton.isEnabled = true
        loginButton.backgroundColor = .white
    }
    
    private func setUILogic() {
        seePasswordButton.isHidden = true
        seePasswordButton.isSelected = false
        rememberMeButton.isSelected = false
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        loginButton.isEnabled = false
        loginButton.backgroundColor = .lightText
        passwordTextField.isSecureTextEntry = true
    }
    
    private func setTextFieldsAttributes() {
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: attributesForTextField
        )
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: attributesForTextField
        )
       
        emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    private func seePasswordButtonSetIcon() {
        seePasswordButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        seePasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
    }
    
    private func rememberMeButtonSetIcon() {
        rememberMeButton.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        rememberMeButton.setImage(UIImage(systemName: "square"), for: .normal)
    }
    
    private func navigateToHome(headers: [String: String]) {
        let storyboard = UIStoryboard(name: Constants.Storyboards.home, bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.home) as! HomeViewController
        homeViewController.userResponse = userResponse
        let authInfo = AuthInfo(headers: headers)
        homeViewController.authInfo = authInfo
        homeViewController.navigationItem.title = "Shows"
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
    
    private func alertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.pulsateButton(self.loginButton)
            self.shakeTextField(textField: self.passwordTextField, numberOfShakes: 1, direction: -1, maxShakes: 2)
            self.shakeTextField(textField: self.emailTextField, numberOfShakes: 1, direction: -1, maxShakes: 2)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func pulsateButton(_ button: UIButton) {
        UIView.animate(
            withDuration: 0.45,
            delay: 0.4,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.5,
            options: [.curveEaseIn, .autoreverse]) {
                button.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
            } completion: { _ in
                button.transform = .identity
            }
    }
    
    func shakeTextField(textField: UITextField, numberOfShakes: Int, direction: CGFloat, maxShakes: Int) {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                textField.transform = CGAffineTransform(translationX: 5 * direction, y: 0)
            }, completion: { (aBool :Bool) -> Void in
                if (numberOfShakes >= maxShakes) {
                    textField.transform = .identity
                    textField.becomeFirstResponder()
                    return
                }
                self.shakeTextField(textField: textField, numberOfShakes: numberOfShakes + 1, direction: direction * -1, maxShakes: maxShakes)
        })
    }
    
    func loadState() -> Bool {
        let isSelected = UserDefaults.standard.bool(
            forKey: Constants.Defaults.rememberMeKey.rawValue
        )
        return isSelected
    }
    
    func saveState(state: Bool, authInfo: AuthInfo) {
        UserDefaults.standard.set(state, forKey: Constants.Defaults.rememberMeKey.rawValue)
        do {
            let encodedData = try JSONEncoder().encode(authInfo)
            UserDefaults.standard.set(encodedData, forKey: Constants.Defaults.switchStateKey.rawValue)
        } catch {
            print("Error encoding AuthInfo: \(error)")
        }
    }
    
    func registerUserResult(email: String, password: String, passwordConfirmation : String) {
        let parameters: [String: String] = [
            "email": email,
            "password": password,
            "password_confirmation": password
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        AF
            .request(
                "https://tv-shows.infinum.academy/users",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                
                switch response.result {
                case .success(let userResponse):
                    if let headers = response.response?.allHeaderFields as? [String: String]{
                        print("Headers: \(headers)")
                        print("Body: \(userResponse)")
                        if rememberMeButton.isSelected {
                            saveState(state: true, authInfo: AuthInfo(headers: headers))
                        }
                        self.userResponse = userResponse
                        navigateToHome(headers: headers)
                    } else {
                        print("Error: Headers not found")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    alertMessage(title: "Register Failure", message: "Register failed, please try again.")
                }
            }
    }
    
    func loginUserResult(email: String, password: String) {
        let parameters: [String: String] = [
            "email": email,
            "password": password,
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        AF
            .request(
                "https://tv-shows.infinum.academy/users/sign_in",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)

                switch response.result {
                case .success(let userResponse):
                    if let headers = response.response?.allHeaderFields as? [String: String]{
                        print("Headers: \(headers)")
                        print("Body: \(userResponse)")
                        if rememberMeButton.isSelected {
                            saveState(state: true, authInfo: AuthInfo(headers: headers))
                        }
                        self.userResponse = userResponse
                        navigateToHome(headers: headers)
                    } else {
                        print("Error: Headers not found")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    alertMessage(title: "Login Failure", message: "Login failed, please try again.")
                }
            }
    }
    
    //MARK: - Actions

    @IBAction private func passwordFieldTapped() {
        passwordTextField.placeholder = nil
        seePasswordButton.isHidden = false

    }
    
    @IBAction private func rememberMeButtonTapped() {
        rememberMeButton.isSelected.toggle()
    }
    
    @IBAction private func seePasswordButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        seePasswordButton.isSelected.toggle()
    }
    
    @IBAction private func loginButtonClicked() {
        if let mail = emailTextField.text, !mail.isEmpty, let pass = passwordTextField.text, !pass.isEmpty {
            loginUserResult(email: mail, password: pass)
        }
    }
    
    @IBAction private func registerButtonClicked() {
        if let mail = emailTextField.text, !mail.isEmpty, let pass = passwordTextField.text, !pass.isEmpty {
            registerUserResult(email: mail, password: pass, passwordConfirmation: pass)
        }
    }
    
}
