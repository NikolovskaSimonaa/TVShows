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
    }
    
    //MARK: - Utility methods
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
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
                    if let headers = response.response?.allHeaderFields as? [String: String],
                        let authorization = headers["Authorization"] {
                        print("Headers: \(headers)")
                        let authInfo = authorization
                        print("Body: \(userResponse)")
                        self.userResponse = userResponse
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                        //homeViewController.userResponse = userResponse
                        //homeViewController.authInfo = authInfo
                        navigationController?.pushViewController(homeViewController, animated: true)
                        navigationController?.setViewControllers([homeViewController], animated: true)
                    } else {
                        print("Error: Authorization header not found")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Register Failure", message: "Register failed, please try again.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alertController, animated: true, completion: nil)
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
                    if let headers = response.response?.allHeaderFields as? [String: String] {
                        print("Headers: \(headers)")
                    }
                    print("Body: \(userResponse)")
                    self.userResponse = userResponse
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                    navigationController?.pushViewController(homeViewController, animated: true)
                    navigationController?.setViewControllers([homeViewController], animated: true)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Failure", message: "Login failed, please try again.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alertController, animated: true, completion: nil)
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
