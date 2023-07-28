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
        setTitle()
        getShowsFromDatabase()
        setupTableView()
    }
    
    //MARK: - Utility methods
    
    private func setTitle() {
        title = "Shows"
        navigationController?.navigationBar.prefersLargeTitles = true
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
                    print("Shows: \(shows)")
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToShowDetails(authInfo: authInfo!, show: shows[indexPath.row])
    }
}
