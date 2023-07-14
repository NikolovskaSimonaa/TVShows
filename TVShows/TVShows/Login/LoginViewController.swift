import UIKit
final class LoginViewController:UIViewController{
    
    @IBOutlet var RememberMeButton: UIButton!
    @IBOutlet var SeePasswordButton: UIButton!
    @IBOutlet var LoginButton: UIButton!
    private var RememberMeButtonIsChecked: Bool = false
    private var SeePasswordButtonIsChecked: Bool = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        LoginButton.layer.cornerRadius = 20
        LoginButton.clipsToBounds = true
        updateRememberMeIcon()
    }
    
    @IBAction private func RememberMeButtonTapped(_ sender: Any){
        RememberMeButtonIsChecked.toggle()
        updateRememberMeIcon()
    }
    
    func updateRememberMeIcon(){
        let iconName = RememberMeButtonIsChecked ? "checkmark.square" : "square"
        let icon = UIImage(named: iconName)
        RememberMeButton.setImage(icon, for: .normal)
    }
    
    @IBAction private func SeePasswordButtonTapped(_ sender: Any) {
        SeePasswordButtonIsChecked.toggle()
        updateSeePasswordIcon()
    }
    func updateSeePasswordIcon(){
        let iconName = SeePasswordButtonIsChecked ? "eye" : "eye.slash.fill"
        let icon = UIImage(named: iconName)
        SeePasswordButton.setImage(icon, for: .normal)
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
        print("Test")
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

