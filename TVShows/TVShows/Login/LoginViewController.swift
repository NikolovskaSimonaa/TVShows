import UIKit

final class LoginViewController:UIViewController{
    
    @IBOutlet var labelCount: UILabel!
    private var numberOfTaps: Int = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print("Test")
    }
    
    @IBAction private func buttonPressed() {
        numberOfTaps = numberOfTaps + 1
        labelCount.text = "\(numberOfTaps)"
    }
}
