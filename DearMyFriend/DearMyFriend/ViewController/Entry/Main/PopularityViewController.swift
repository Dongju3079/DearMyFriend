import UIKit

class PopularityViewController: UIViewController {
    
    var startSeting: Bool = false
    var mainPage: MainViewController?
    var storyTime = Timer()
    var pageOfNumber = 0
    var storyDuration: TimeInterval = IndicatorInfo.duration
    var nowCell: PopularityCellView?
    var nextCell: PopularityCellView?
    private var initialY: CGFloat = 0.0
    private var translationY: CGFloat = 0.0
    // 프로필 이미지
    let rankCollectionView : UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rankCollectionView)
        view.backgroundColor = .black
        autoLayout()
        setupCollectionView()
        setupTimer()
    }
    
    func autoLayout() {
        NSLayoutConstraint.activate([
            rankCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            rankCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            rankCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            rankCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    func setupCollectionView() {
        self.rankCollectionView.dataSource = self
        self.rankCollectionView.delegate = self
        self.rankCollectionView.register(PopularityCellView.self, forCellWithReuseIdentifier: Collection.rankStoryIdentifier)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(panGesture) // 이 줄 주석 해제
    }
    
    func indicatorControl(_ indicator: IndicatorCircle, _ touchBool: Bool) {
        if touchBool {
            // presentation : layer 가 그려진 정도
            guard let presentation = indicator.indicatorLayer.presentation() else { return }
            indicator.indicatorLayer.strokeEnd = presentation.strokeEnd
            indicator.indicatorLayer.removeAllAnimations()
            
            let duration = CGFloat(IndicatorInfo.duration)
            let remainingTime = duration - (presentation.strokeEnd * duration)
            indicator.remainingTime = remainingTime
            indicator.startPoint = presentation.strokeEnd
            storyDuration = remainingTime
            storyTime.invalidate()
        } else {
            indicator.animateForegroundLayer()
            setupTimer()
        }
    }
    
    func setupTimer() {
        if !storyTime.isValid {
            storyTime = Timer.scheduledTimer(timeInterval: storyDuration , target: self, selector: #selector(timerCounter), userInfo: nil, repeats: false)
        }
    }
    
    @objc func timerCounter() {

        if pageOfNumber < 4 {
            pageOfNumber += 1
            storyDuration = IndicatorInfo.duration
            rankCollectionView.scrollToItem(at: [0, pageOfNumber], at: .left, animated: true)
            setupTimer()
        } else {
            self.storyTime.invalidate()
            self.mainPage?.setupTimer()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let maxYTranslation: CGFloat = 100 // 최대 이동 거리
        
        switch gesture.state {
        case .began:
            indicatorControl(nowCell!.indicatorCircle, true)
            initialY = rankCollectionView.frame.origin.y
        case .changed:
            if translation.y > 0 && translation.y <= maxYTranslation {
                translationY = translation.y
                rankCollectionView.frame.origin.y = initialY + translationY
            }
        case .ended:
            if translationY > maxYTranslation*0.6 {
                self.mainPage?.setupTimer()
                self.dismiss(animated: true, completion: nil)
                self.storyTime.invalidate()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.rankCollectionView.frame.origin.y = self.initialY
                }
                indicatorControl(nowCell!.indicatorCircle, false)
                self.setupTimer()
            }
        default:
            break
        }
    }
}

extension PopularityViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Rankbanner.image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Collection.rankStoryIdentifier, for: indexPath) as! PopularityCellView
        if self.nowCell == nil {
            self.nowCell = cell
            self.nowCell?.indicatorCircle.resetTime()
        }
        
        cell.toucheOfImage = { [weak self] (senderCell) in
            self?.indicatorControl(senderCell.indicatorCircle, PopularityTouch.touch)
        }
        cell.petPhoto.image = Rankbanner.image[indexPath.item]
        return cell
    }
    
    
}

extension PopularityViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let popularityCell = cell as? PopularityCellView else { return }
        self.nextCell = popularityCell
        if startSeting == true {
            self.nextCell?.indicatorCircle.indicatorLayer.removeFromSuperlayer()
            self.storyTime.invalidate()
            self.storyDuration = IndicatorInfo.duration
        }
        startSeting = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.setupTimer()
        self.nextCell?.indicatorCircle.resetTime()
        guard let popularityCell = cell as? PopularityCellView else { return }
    }
}

extension PopularityViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
    }
}

extension PopularityViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        let intPage = Int(page)
        if pageOfNumber != intPage {
            pageOfNumber = intPage
            self.nowCell = self.nextCell
            self.storyTime.invalidate()
            self.storyDuration = IndicatorInfo.duration
            self.setupTimer()
        } else {
            self.storyTime.invalidate()
            self.storyDuration = IndicatorInfo.duration
            self.setupTimer()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indicatorControl(self.nowCell!.indicatorCircle, true)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        indicatorControl(self.nowCell!.indicatorCircle, false)
    }
}
