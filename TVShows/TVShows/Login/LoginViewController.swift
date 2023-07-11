//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Academy 7 on 11.7.23.
//

//import Foundation
import UIKit

class LoginViewController:UIViewController{
    
    //@IBOutlet weak var labelCount: UILabel!
    @IBOutlet var labelCount: UILabel!
    var count:Int=0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print("Test")
    }
    
    @IBAction func buttonTouchUpInside(_ sender: Any) {
        count=count+1
        labelCount.text = "\(count)"
    }
}
