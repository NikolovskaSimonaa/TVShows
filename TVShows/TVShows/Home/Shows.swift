import Alamofire
import MBProgressHUD
import UIKit

final class HomeViewController:UIViewController {
    //MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Properties
    
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    private var shows: [Show] = []
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getShowsFromDatabase()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - Utility methods
    
    private func getShowsFromDatabase() {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        guard let authInfo else {
            return
        }
        
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
}

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
        //return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
