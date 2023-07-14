import UIKit
import MBProgressHUD

final class LoginViewController:UIViewController{
    
    @IBOutlet var labelCount: UILabel!
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
}

