import UIKit
final class LoginViewController:UIViewController{
    
    @IBOutlet var RememberMeButton: UIButton!
    @IBOutlet var SeePasswordButton: UIButton!
    @IBOutlet var LoginButton: UIButton!
    @IBOutlet var PasswordTextField: UITextField!
    @IBOutlet var RegisterButton: UIButton!
    private var RememberMeButtonIsChecked: Bool = false
    private var SeePasswordButtonIsChecked: Bool = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        SeePasswordButton.isHidden = true
        SeePasswordButton.isSelected = false
        RememberMeButton.isSelected = false
        LoginButton.layer.cornerRadius = 20
        LoginButton.clipsToBounds = true
        LoginButton.isEnabled = false
        LoginButton.backgroundColor = .lightText
        //RegisterButton.isEnabled = false
        //RegisterButton.setTitleColor(.lightText, for: .normal)
    }
    
    @IBAction private func PasswordFieldTapped() {
        PasswordTextField.placeholder = nil
        SeePasswordButton.isHidden = false
        PasswordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction private func RememberMeButtonTapped(_ sender: UIButton){
        if sender.isSelected {
            sender.setImage(UIImage(named: "checkmark.square.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "square"), for: .normal)
        }
        sender.isSelected.toggle()
    }
    
    @IBAction private func SeePasswordButtonTapped(_ sender: UIButton) {
        //SeePasswordButtonIsChecked.toggle()
        PasswordTextField.isSecureTextEntry.toggle()
        if sender.isSelected {
            sender.setImage(UIImage(named: "eye.slash.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "eye"), for: .normal)
        }
        sender.isSelected.toggle()
    }
}
    
/*    @IBOutlet var labelCount: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    private var numberOfTaps: Int = 0

    override func viewDidLoad(){
        super.viewDidLoad()
        startActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.stopActivityIndicator()
        }
    }
    
    @IBAction private func buttonPressed() {
        if activityIndicator.isAnimating{
            numberOfTaps = numberOfTaps + 1
            labelCount.text = "\(numberOfTaps)"
            stopActivityIndicator()
        }else{
            startActivityIndicator()
        }
    }
    
    func startActivityIndicator(){
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator(){
        activityIndicator.stopAnimating()
    }
}*/

