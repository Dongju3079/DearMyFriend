import UIKit
import Lottie

class MainViewController: UIViewController {
    //
    let appManager = AppNetworking.shared
    var bannerImageList: [Int:String] = [:]
    var appList: [SearchResult] = []
    var searchKeyword = "펫용품"
    var pageOfNumber = 1
    var bannerTime = Timer()
    var placeArray: [RecommendationPlace] = []
    
    let mainView: MainView = {
        let view = MainView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let MenuViewControllers = [YouTubeViewController(), MapViewController(), CalculatorViewController()]
    
    private let bringView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "bring")
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.contentMode = .scaleAspectFill
        animation.loopMode = .loop
        return animation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAppList()
        setupBanner()
        setupPlace()
        autoLayout()
        setupCollectionView()
    }
    
    func setupPlace() {
        RecommendationPlaceService.shared.uploadPlace { result in
            switch result {
            case .success(let placeData):
                self.placeArray = placeData
                self.mainView.recommendedPlace.reuseCollection.reloadData()
            case .failure(let error):
                AlertManager.recommendationPlaceReadFail(on: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.setupTimer()
        self.bringView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.bannerTime.invalidate()
    }
    
    func autoLayout() {
        self.view.addSubview(mainView)
        self.view.addSubview(bringView)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            bringView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            bringView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            bringView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2),
            bringView.heightAnchor.constraint(equalTo: self.bringView.widthAnchor)
        ])
    }
    
    func setupCollectionView() {
        mainView.menuCollectionView.tag = 0
        mainView.menuCollectionView.dataSource = self
        mainView.menuCollectionView.delegate = self
        mainView.menuCollectionView.register(MainMenuCellView.self, forCellWithReuseIdentifier: Collection.menuIdentifier)
        
        mainView.rankCollectionView.tag = 1
        mainView.rankCollectionView.dataSource = self
        mainView.rankCollectionView.delegate = self
        mainView.rankCollectionView.register(RankImageCellView.self, forCellWithReuseIdentifier: Collection.rankIdentifier)
        
        mainView.recommendedStore.reuseCollection.tag = 2
        mainView.recommendedStore.reuseCollection.dataSource = self
        mainView.recommendedStore.reuseCollection.delegate = self
        mainView.recommendedStore.reuseCollection.register(MainMenuCellView.self, forCellWithReuseIdentifier: Collection.storeIdentifier)
        
        mainView.recommendedPlace.reuseCollection.tag = 3
        mainView.recommendedPlace.reuseCollection.dataSource = self
        mainView.recommendedPlace.reuseCollection.delegate = self
        mainView.recommendedPlace.reuseCollection.register(RankImageCellView.self, forCellWithReuseIdentifier: Collection.placeIdentifier)
    }
    
    func setupBanner() {
        bannerImageList = StorageService.shared.bannerUrl
        if !bannerImageList.isEmpty {
            bannerImageList.updateValue(bannerImageList[bannerImageList.count-1]!, forKey: 0)
            bannerImageList.updateValue(bannerImageList[1]!, forKey: bannerImageList.count)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if !bannerImageList.isEmpty {
            mainView.rankCollectionView.scrollToItem(at: [0, 1], at: .left, animated: false)
        }
    }
    
    func setupTimer() {
        if !bannerTime.isValid && !bannerImageList.isEmpty {
            bannerTime = Timer.scheduledTimer(timeInterval: 5 , target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            RunLoop.current.add(bannerTime, forMode: .common)
        }
    }
    
    @objc func timerCounter() {
        if pageOfNumber < bannerImageList.count-2 {
            pageOfNumber += 1
            mainView.rankCollectionView.scrollToItem(at: [0, pageOfNumber], at: .left, animated: true)
        } else {
            pageOfNumber = 1
            mainView.rankCollectionView.scrollToItem(at: [0, pageOfNumber], at: .left, animated: true)
        }
    }
    
    func setupAppList() {
        appManager.fetchMusic(searchTerm: searchKeyword) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let apps):
                self.appList = apps
                DispatchQueue.main.async {
                    self.mainView.recommendedStore.reuseCollection.reloadData()
                }
            case .failure(_):
                AlertManager.errorAlert(on: self)
            }
        }
    }
    
    private func showWebViewController(with urlString: String) {
        let vc = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return MenuViewControllers.count
        case 1:
            mainView.pageControl.numberOfPages = bannerImageList.count-2
            return bannerImageList.count
        case 2:
            return appList.count
        case 3:
            return self.placeArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Collection.menuIdentifier, for: indexPath) as! MainMenuCellView
            cell.iconSet = MenuTest.allMenu[indexPath.item]
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Collection.rankIdentifier, for: indexPath) as! RankImageCellView
            cell.bannerTouchesBegan = { [weak self] in
                guard let self = self else { return }
                self.bannerTime.invalidate()
            }
            cell.bannerTouchesEnded = { [weak self] in
                guard let self = self else { return }
                self.setupTimer()
            }
            cell.bannerImage = bannerImageList[indexPath.item]
            cell.myImageView.backgroundColor = ThemeColor.pink
            cell.myImageView.layer.cornerRadius = 0
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Collection.storeIdentifier, for: indexPath) as! MainMenuCellView
            cell.appStore = appList[indexPath.item]
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Collection.placeIdentifier, for: indexPath) as! RankImageCellView
            cell.placeData = self.placeArray[indexPath.item]
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(MenuViewControllers[indexPath.row], animated: false)
        case 1:
            switch indexPath.item {
            case 2:
                self.bringView.isHidden = false
                self.bringView.play()

                StorageService.shared.bringStoryImage { [weak self] result, error in
                    guard let self = self else { return }
                    
                    if error != nil {
                        return
                    }
                    self.bringView.stop()
                    guard let result = result else { return }
                    let popularityView = PopularityViewController()
                    popularityView.mainPage = self
                    popularityView.storyImages = result
                    popularityView.modalTransitionStyle = .crossDissolve
                    popularityView.modalPresentationStyle = .fullScreen
                    self.present(popularityView, animated: true) {
                        self.bannerTime.invalidate()
                    }
                }
                
    
                // firebase에서 정보받아올수있게 변경 필요
            case 3:
                let urlString = "https://hyewon07.tistory.com/entry/%EB%B0%98%EB%A0%A4%EB%8F%99%EB%AC%BC-%EC%A0%95%EB%B6%80-%EC%A7%80%EC%9B%90%EA%B8%88"
                self.showWebViewController(with: urlString)
            default:
                return
            }
            
        case 2:
            guard let appStore = appList[indexPath.item].appUrl else { return }
            if let url = URL(string: appStore) {
                UIApplication.shared.open(url, options: [:])
            }
        case 3:
            guard let urlString = self.placeArray[indexPath.item].pageUrl else { return }
            self.showWebViewController(with: urlString)
        default:
            return
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt                            indexPath: IndexPath) -> CGSize {
        
        switch collectionView.tag {
        case 0:
            return CGSize(width: Collection.menuSize, height: Collection.cellHeightSize)
        case 1:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case 2:
            return CGSize(width: Collection.reuseStoreWidtSize, height: Collection.reuseStoreHeightSize)
        default:
            return CGSize(width: CGFloat(Collection.reusePlaceWidtSize), height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch collectionView.tag {
        case 1:
            return UIEdgeInsets()
        case 0, 2, 3:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        default:
            return UIEdgeInsets()
        }
        
    }
}

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainView.rankCollectionView {
            let pageCoordinate = scrollView.contentOffset.x - scrollView.frame.width
            
            if scrollView.frame.size.width != 0 {
                let value = (pageCoordinate / scrollView.frame.width)
                mainView.pageControl.currentPage = Int(round(value))
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == mainView.rankCollectionView {
            let last = bannerImageList.count-2
            if scrollView.contentOffset.x == 0  {
                mainView.rankCollectionView.scrollToItem(at: [0, last], at: .left, animated: false)
            }
            if scrollView.contentOffset.x == scrollView.frame.width * CGFloat(bannerImageList.count-1)  {
                mainView.rankCollectionView.scrollToItem(at: [0, 1], at: .left, animated: false)
            }
            
            let page = scrollView.contentOffset.x / scrollView.frame.width
            let intPage = Int(page)
            pageOfNumber = intPage
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == mainView.rankCollectionView {
            bannerTime.invalidate()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == mainView.rankCollectionView {
            setupTimer()
        }
    }
}
