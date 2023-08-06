import Alamofire
import MBProgressHUD
import UIKit

final class HomeViewController:UIViewController {
    //MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Public Properties
    
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    
    //MARK: - Private Properties
    
    private var shows: [Show] = []
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        getShowsFromDatabase()
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogout), name: .didLogout, object: nil)
    }
    
    //MARK: - Utility methods
    
    private func setupNavigationBar() {
        title = "Shows"
        navigationController?.navigationBar.prefersLargeTitles = true
        let profileDetailsItem = UIBarButtonItem(
            image: UIImage(named: "ic-profile"),
            style: .plain,
            target: self,
            action: #selector(profileDetailsActionHandler))
        navigationItem.rightBarButtonItem = profileDetailsItem
    }
    
    @objc func profileDetailsActionHandler() {
        guard let authInfo = self.authInfo else { return }
        let storyboard = UIStoryboard(name: Constants.Storyboards.profileDetails, bundle: nil)
        let profileDetailsViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.profileDetails) as! ProfileDetailsViewController
        profileDetailsViewController.authInfo = authInfo
        let navigationController = UINavigationController(rootViewController: profileDetailsViewController)
        present(navigationController, animated: true)
    }
    
    @objc func handleLogout() {
        let storyboard = UIStoryboard(name: Constants.Storyboards.login, bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.login) as! LoginViewController
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
    
    private func getShowsFromDatabase() {
        guard let authInfo else { return }
        MBProgressHUD.showAdded(to: view, animated: true)
        AF
            .request(
                "https://tv-shows.infinum.academy/shows",
                method: .get,
                parameters: ["page": "1", "items": "100"],
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: ShowsResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success(let showsResponse):
                    shows = showsResponse.shows
                    tableView.reloadData()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func navigateToShowDetails(authInfo: AuthInfo, show: Show) {
        let storyboard = UIStoryboard(name: Constants.Storyboards.showDetails, bundle: nil)
        let showDetailsViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.showDetails) as! ShowDetailsViewController
        showDetailsViewController.showModel = show
        showDetailsViewController.authInfo = authInfo
        navigationController?.pushViewController(showDetailsViewController, animated: true)
      }
}

    //MARK: - Extensions

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowTableViewCell.self), for: indexPath) as! ShowTableViewCell
        let show = shows[indexPath.row]
        cell.configure(with: show)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToShowDetails(authInfo: authInfo!, show: shows[indexPath.row])
    }
}
