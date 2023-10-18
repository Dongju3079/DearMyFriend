// FeedViewController
// Feed View
// Feed 화면에서 게시글을 보여주는 View
// 해당 View는 FeedViewController에서 TableView에 들어가는 Cell에 들어갈 View 이다.

import Foundation
import UIKit

class FeedView: UIView {
    // MARK: Properties
    // ImageView
    let imageFrame: CGFloat = 40
    // Label
    let userNicknameLabelSize: CGFloat = 15
    // Image CollectionView & Page Control
    let imageCollectionViewHeight: CGFloat = 200
    let imageNames: [String] = ["spider1", "spider2", "spider3"]
    let pageControlHeight: CGFloat = 30
    // Like & Comment Button
    let buttonFrame: CGFloat = 50
    let buttonSize: CGFloat = 30
    let buttonPadding: CGFloat = 8
    let likeButtonImage: String = "heart"
    let likeButtonColor: UIColor = .black
    let commentButtonImage: String = "message"
    let commentButtonColor: UIColor = .black
    // TextView
    let postTextViewHeight: CGFloat = 100
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "spider1")
        
        imageView.frame = CGRect(x: 0, y: 0, width: imageFrame, height: imageFrame)
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        
        return imageView
    }()
    
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
        
        button.frame = CGRect(x: 0, y: 0, width: buttonFrame, height: buttonFrame) // image Button 크기 지정.
        
        let resizedImage = resizeUIImage(imageName: likeButtonImage, heightSize: buttonSize)
        button.setImage(resizedImage, for: .normal)
        
        // 패딩 설정
        let padding = UIEdgeInsets(top: buttonPadding, left: buttonPadding, bottom: buttonPadding, right: buttonPadding)
        button.contentEdgeInsets = padding
        
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: buttonFrame, height: buttonFrame)
        
        let resizedImage = resizeUIImage(imageName: commentButtonImage, heightSize: buttonSize)
        button.setImage(resizedImage, for: .normal)
        
        // 패딩 설정
        let padding = UIEdgeInsets(top: buttonPadding, left: buttonPadding, bottom: buttonPadding, right: buttonPadding)
        button.contentEdgeInsets = padding
        
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
        [profileImageView, userNicknameLabel, imageCollectionView, pageControl, likeButton, commentButton, postTextView].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setProfileImageViewConstraint()
        setNicknameLabelConstraint()
        setImageCollectionViewConstraint()
        setPageControlConstraint()
        setLikeButtonConstraint()
        setCommentButtonConstraint()
        setPostTextViewConstraint()
    }
    
    // MARK: - Constant
    // Profile Image
    let profileHeight: CGFloat = 40
    let profileWidth: CGFloat = 40
    let profileLeadingConstant: CGFloat = 8
    // Nickname Label
    let topViewHeight: CGFloat = 40
    let userNicknameLeadingConstant: CGFloat = 12
    // Image Collection
    let imageCollectionTopConstant: CGFloat = 8
    // Like & Comment Button
    let likeLeadingConstant: CGFloat = 2
    
    private func setProfileImageViewConstraint() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: profileLeadingConstant),
            profileImageView.heightAnchor.constraint(equalToConstant: profileHeight),
            profileImageView.widthAnchor.constraint(equalToConstant: profileWidth)
        ])
    }
    
    private func setNicknameLabelConstraint() {
        NSLayoutConstraint.activate([
            userNicknameLabel.topAnchor.constraint(equalTo: topAnchor),
            userNicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: userNicknameLeadingConstant),
            userNicknameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            userNicknameLabel.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
    
    private func setImageCollectionViewConstraint() {
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: imageCollectionTopConstant),
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
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: likeLeadingConstant),
        ])
    }
    
    private func setCommentButtonConstraint() {
        NSLayoutConstraint.activate([
            commentButton.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor),
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
    
    // MARK: - Helper
    // 이미지를 조절하고 싶었으나, SF Symbol이
    private func resizeUIImage(imageName: String, heightSize: Double) -> UIImage {
        let image = UIImage(systemName: imageName)
        // 원하는 높이를 설정
        let targetHeight: CGFloat = heightSize
        
        // 원래 이미지의 비율을 유지하면서 이미지 리사이즈
        let originalAspectRatio = image!.size.width / image!.size.height
        let targetWidth = targetHeight * originalAspectRatio
        
        // 목표 크기 설정
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        
        // SF Symbol Configuration을 생성하고 weight를 변경
        let configuration = UIImage.SymbolConfiguration(weight: .medium)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image?.withConfiguration(configuration).draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
}


