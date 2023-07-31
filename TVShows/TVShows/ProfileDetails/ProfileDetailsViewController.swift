import Alamofire
import Kingfisher
import UIKit

class ProfileDetailsViewController: UIViewController, UINavigationControllerDelegate {

    //MARK: - Outlets
    
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var profileImage: UIImageView!
    @IBOutlet private var logoutButton: UIButton!
    
    //MARK: - Properties
    
    var user: User?
    var authInfo: AuthInfo?
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUIlogic()
    }
    
    //MARK: - Utility methods

    private func setupUIlogic(){
        logoutButton.layer.cornerRadius = 25
        logoutButton.clipsToBounds = true
        emailLabel.text = user?.email ?? "User not found"
        if let image = user?.imageUrl {
            profileImage.kf.setImage(
                with: URL(string: image),
                placeholder: UIImage(named: "ic-profile-placeholder"))
        }
    }
    
    private func setupNavigationBar() {
        title = "My Account"
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonClicked))
        closeButton.tintColor = UIColor(red: 82.0/255.0, green: 54.0/255.0, blue: 140.0/255.0, alpha: 1)
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    private func storeImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else { return }
        guard let authInfo = self.authInfo, let user = self.user else { return }
        let headers: HTTPHeaders = [
            "uid": authInfo.headers["uid"] ?? user.email,
            "client": authInfo.headers["client"] ?? "",
            "access-token": authInfo.headers["access-token"] ?? ""
            
        ]
        
        /*let parameters: [String: String] = [
            "email": user.email,
            "password": ,
            "password_confirmation":
        ]*/
        
        let requestData = MultipartFormData()
        requestData.append(
            imageData, withName: "image",
            fileName: "image.jpg",
            mimeType: "image/jpg"
        )
        AF
            .upload(multipartFormData: requestData,
                    to: "https://tv-shows.infinum.academy/users",
                    method: .put,
                    headers: headers
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
                switch response.result {
                case .success(let userResponse):
                    self.user = userResponse.user
                    self.authInfo = AuthInfo(headers: response.response?.allHeaderFields as? [String: String] ?? [:])
                    if let imageString = userResponse.user.imageUrl, let imageUrl = URL(string: imageString) {
                        self.profileImage.kf.setImage(with: imageUrl)
                    }
                    //self.setupUIlogic()
                case .failure(let error):
                    print("Error uploading image: \(error.localizedDescription)")
                }
            }
    }
    
    //MARK: - Actions
    
    @IBAction private func logoutButtonClicked() {
        dismiss(animated: true) {
            UserDefaults.standard.removeObject(forKey: Constants.Defaults.switchStateKey.rawValue)
            UserDefaults.standard.removeObject(forKey: Constants.Defaults.rememberMeKey.rawValue)
            NotificationCenter.default.post(name: .didLogout, object: nil)
        }
    }
    
    @IBAction func changePhotoButtonClicked() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
}
//MARK: - Extensions

extension ProfileDetailsViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.contentMode = .scaleAspectFit
            profileImage.image = pickedImage
            storeImage(pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
