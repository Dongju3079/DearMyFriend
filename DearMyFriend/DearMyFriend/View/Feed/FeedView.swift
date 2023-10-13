// FeedViewController
// Feed View
// Feed 화면에서 게시글을 보여주는 View
// 해당 View는 FeedViewController에서 TableView에 들어가는 Cell에 들어갈 View 이다.
import Foundation
import UIKit

class FeedView: UIView {
    // MARK: Properties
    // View
    let topViewHeight: CGFloat = 50
    // Label
    let userNicknameLabelSize: CGFloat = 15
    // Button
    let likeButtonSize: CGFloat = 30
    let likeButtonImage: String = "heart"
    let likeButtonColor: UIColor = .black
    // image scrollView
    let imageScrollViewHeight: CGFloat = 200
    var imageViews: [UIImageView] = []
    let imageNames: [String] = ["spider1", "spider2", "spider3"]
    
    lazy var userNicknameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: userNicknameLabelSize)
        label.text = "사용자 닉네임" // 추후 파이어베이스로 받아온 사용자의 닉네임 표시
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: likeButtonSize, weight: .light)
        let image = UIImage(systemName: likeButtonImage, withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = likeButtonColor
        
        return button
    }()
    
    lazy var imageCollectionView: UICollectionView = {
        // collectionView layout setting
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal // 스크롤 방향 설정
        layout.minimumLineSpacing = 0 // 라인 간격
        layout.minimumInteritemSpacing = 0 // 항목 간격
        layout.footerReferenceSize = .zero // 헤더 사이즈 설정
        layout.headerReferenceSize = .zero // 푸터 사이즈 설정
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true // 스크롤 활성화
        collectionView.isPagingEnabled = true // 페이징 활성화
        collectionView.showsHorizontalScrollIndicator = false // 수평 스크롤바를 숨김.
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.backgroundColor = .red
        
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .yellow
        pageControl.pageIndicatorTintColor = .green
        
        return pageControl
    }()
    
    // MARK: Initalizers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    private func configure() {
        setUI()
        setConstraint()
    }
    
    private func setUI(){
        [userNicknameLabel, likeButton, imageCollectionView, pageControl].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setNicknameLabelConstraint()
        setLikeButtonConstraint()
        setImageCollectionViewConstraint()
        setPageControlConstraint()
    }
    
    private func setNicknameLabelConstraint() {
        NSLayoutConstraint.activate([
            userNicknameLabel.topAnchor.constraint(equalTo: topAnchor),
            userNicknameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            userNicknameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setLikeButtonConstraint() {
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
    
    private func setImageCollectionViewConstraint() {
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: userNicknameLabel.bottomAnchor, constant: 10),
            imageCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageCollectionView.widthAnchor.constraint(equalToConstant: 200),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func setPageControlConstraint() {
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 10),
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
//            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Action
//    func collectionViewDelegate() {
//        imageCollectionView.delegate = self
//    }
//
//    func collectionViewDataSource() {
//        imageCollectionView.dataSource = self
//    }
}


