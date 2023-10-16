// FeedViewController
// Feed View
// Feed 화면에서 게시글을 보여주는 View
// 해당 View는 FeedViewController에서 TableView에 들어가는 Cell에 들어갈 View 이다.
import Foundation
import UIKit

class FeedView: UIView {
    // MARK: Properties
    // Label & Button
    let topViewHeight: CGFloat = 30
    let userNicknameLabelSize: CGFloat = 15
    let ButtonSize: CGFloat = 20
    let likeButtonImage: String = "heart"
    let likeButtonColor: UIColor = .black
    let commentButtonImage: String = "message"
    let commentButtonColor: UIColor = .black
    // Image CollectionView & Page Control
    let imageCollectionViewHeight: CGFloat = 200
    let imageNames: [String] = ["spider1", "spider2", "spider3"]
    let pageControlHeight: CGFloat = 30
    // TextView
    let postTextViewHeight: CGFloat = 100
    
    lazy var userNicknameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: userNicknameLabelSize)
        label.text = "사용자 닉네임" // 추후 파이어베이스로 받아온 사용자의 닉네임 표시
        label.textAlignment = .left
        
        return label
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
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: ButtonSize, weight: .light)
        let image = UIImage(systemName: likeButtonImage, withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = likeButtonColor
        
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: ButtonSize, weight: .light)
        let image = UIImage(systemName: commentButtonImage, withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = commentButtonColor
        
        return button
    }()
    
    lazy var postTextView: UITextView = {
       let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        
        textView.backgroundColor = .blue
        textView.text = "Test 입니다."
        
        return textView
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
        [userNicknameLabel, imageCollectionView, pageControl, likeButton, commentButton, postTextView].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setNicknameLabelConstraint()
        setImageCollectionViewConstraint()
        setPageControlConstraint()
        setLikeButtonConstraint()
        setCommentButtonConstraint()
        setPostTextViewConstraint()
    }
    
    private func setNicknameLabelConstraint() {
        NSLayoutConstraint.activate([
            userNicknameLabel.topAnchor.constraint(equalTo: topAnchor),
            userNicknameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            userNicknameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            userNicknameLabel.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
    
    private func setImageCollectionViewConstraint() {
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: userNicknameLabel.bottomAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            imageCollectionView.widthAnchor.constraint(equalToConstant: 200),
            imageCollectionView.heightAnchor.constraint(equalToConstant: imageCollectionViewHeight),
        ])
    }
    
    private func setPageControlConstraint() {
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: -pageControlHeight),
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: pageControlHeight)
        ])
    }
    
    private func setLikeButtonConstraint() {
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            likeButton.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
    
    private func setCommentButtonConstraint() {
        NSLayoutConstraint.activate([
            commentButton.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 10),
            commentButton.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
    
    private func setPostTextViewConstraint() {
        NSLayoutConstraint.activate([
            postTextView.topAnchor.constraint(equalTo: likeButton.bottomAnchor),
            postTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            postTextView.heightAnchor.constraint(equalToConstant: postTextViewHeight)
        ])
    }
}


