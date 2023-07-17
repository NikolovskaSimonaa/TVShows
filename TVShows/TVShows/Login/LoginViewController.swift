import UIKit
final class LoginViewController:UIViewController {
    
    @IBOutlet private var seePasswordButton: UIButton!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var registerButton: UIButton!
    @IBOutlet private var rememberMeButton: UIButton!
    private let attributesForTextField: [NSAttributedString.Key: Any] = [
        .foregroundColor : UIColor.white.withAlphaComponent(0.7),
        .font : UIFont.systemFont(ofSize: 17)
    ]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setUILogic()
        seePasswordButtonSetIcon()
        rememberMeButtonSetIcon()
        setTextFieldsAttributes()
    }
    
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

    @IBAction private func passwordFieldTapped() {
        passwordTextField.placeholder = nil
        seePasswordButton.isHidden = false

    }
    
    @IBAction private func rememberMeButtonTapped() {
        rememberMeButton.isSelected.toggle()
    }
    
    @IBAction func seePasswordButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        seePasswordButton.isSelected.toggle()
    }
}
