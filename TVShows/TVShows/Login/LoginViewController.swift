import UIKit
final class LoginViewController:UIViewController{
    
    @IBOutlet var RememberMeButton: UIButton!
    @IBOutlet var SeePasswordButton: UIButton!
    @IBOutlet var LoginButton: UIButton!
    @IBOutlet var PasswordTextField: UITextField!
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var RegisterButton: UIButton!
    private let attributesForTextField: [NSAttributedString.Key: Any] = [
        .foregroundColor : UIColor.white.withAlphaComponent(0.7),
        .font : UIFont.systemFont(ofSize: 17)
    ]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        SeePasswordButton.isHidden = true
        SeePasswordButton.isSelected = false
        RememberMeButton.isSelected = false
        LoginButton.layer.cornerRadius = 20
        LoginButton.clipsToBounds = true
        LoginButton.isEnabled = false
        LoginButton.backgroundColor = .lightText
        PasswordTextField.isSecureTextEntry = true
        
        SeePasswordButtonSetIcon()
        
        RememberMeButtonSetIcon()
        
        EmailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: attributesForTextField
        )
        
        PasswordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: attributesForTextField
        )
    }
    
    private func SeePasswordButtonSetIcon(){
        SeePasswordButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        SeePasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
    }
    
    private func RememberMeButtonSetIcon(){
        RememberMeButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        RememberMeButton.setImage(UIImage(systemName: "square"), for: .normal)
    }
    
    @IBAction private func PasswordFieldTapped() {
        PasswordTextField.placeholder = nil
        SeePasswordButton.isHidden = false
    }
    
    @IBAction private func RememberMeButtonTapped(_ sender: UIButton){
        sender.isSelected.toggle()
    }
    
    @IBAction private func SeePasswordButtonTapped(_ sender: UIButton) {
        PasswordTextField.isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
    
}

