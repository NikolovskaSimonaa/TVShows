import UIKit
final class LoginViewController:UIViewController, UITextFieldDelegate {
    
    @IBOutlet var rememberMeButton: UIButton!
    @IBOutlet var seePasswordButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var registerButton: UIButton!
    private let attributesForTextField: [NSAttributedString.Key: Any] = [
        .foregroundColor : UIColor.white.withAlphaComponent(0.7),
        .font : UIFont.systemFont(ofSize: 17)
    ]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        seePasswordButton.isHidden = true
        seePasswordButton.isSelected = false
        rememberMeButton.isSelected = false
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        loginButton.isEnabled = false
        loginButton.backgroundColor = .lightText
        passwordTextField.isSecureTextEntry = true
        
        SeePasswordButtonSetIcon()
        
        RememberMeButtonSetIcon()
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: attributesForTextField
        )
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: attributesForTextField
        )
        
        [emailTextField, passwordTextField].forEach({
            $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        })
    }
    
    @objc func editingChanged(_ textField: UITextField){
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
            return
        }
        loginButton.isEnabled = true
    }
    
    private func SeePasswordButtonSetIcon(){
        seePasswordButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        seePasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
    }
    
    private func RememberMeButtonSetIcon(){
        rememberMeButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        rememberMeButton.setImage(UIImage(systemName: "square"), for: .normal)
    }
    
    @IBAction private func PasswordFieldTapped() {
        passwordTextField.placeholder = nil
        seePasswordButton.isHidden = false
    }
    
    @IBAction private func RememberMeButtonTapped(_ sender: UIButton){
        sender.isSelected.toggle()
    }
    
    @IBAction private func SeePasswordButtonTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
}
