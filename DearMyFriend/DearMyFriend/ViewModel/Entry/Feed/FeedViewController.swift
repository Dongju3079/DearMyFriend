import UIKit

class FeedViewController: UIViewController {
    
    // MARK: Properties
    let feedTitleView: FeadTitleView = .init(frame: .zero)
    let feedTitleViewHeight: CGFloat = 50
    
    // TableView
    private let feedTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
//        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // NavigationBar 숨김.
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Configure
    private func configure() {
        view.backgroundColor = .white
        setupFeedTitleView()
        setupTableView()
//        setupImageCollectionView()
    }
    
    private func setupFeedTitleView() {
        view.addSubview(feedTitleView)
        feedTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            feedTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedTitleView.heightAnchor.constraint(equalToConstant: feedTitleViewHeight)
        ])
    }
    
    func setupTableView(){
        feedTableView.dataSource = self
        feedTableView.rowHeight = 300
        
        feedTableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        
        setTableViewConstraints()
    }
    
    func setTableViewConstraints() {
        view.addSubview(feedTableView)
        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            feedTableView.topAnchor.constraint(equalTo: feedTitleView.bottomAnchor),
            feedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // 추후 받아오는 데이터 정보에 따라 표시되는 수 설정
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as! FeedTableViewCell
        
        return cell
    }
}
