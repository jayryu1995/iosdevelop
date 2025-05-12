import UIKit

class TabBarViewController: UITabBarController {
    
    static let shared = TabBarViewController()
    
    var chatVC: UIViewController = ChatsListVC()
    var notificationVC = NotificationVC()
    private(set) var viewModel = NotificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupViewControllers()
        setupObservers()
        loadAlarmNotification()
        initSendBird()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
