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
    let userNicknameLabelSize: CGFloat = 20
    
    // Button
    let likeButtonSize: CGFloat = 30
    let likeButtonImage: String = "heart"
    let likeButtonColor: UIColor = .black
    
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
    
    // 작성자와 좋아요 버튼 묶음.
    lazy var topView: UIView = {
        let view = UIView()
        
        view.addSubview(userNicknameLabel)
        view.addSubview(likeButton)
        
        return view
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
        [userNicknameLabel, likeButton, topView].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setNicknameLabelConstraint()
        setLikeButtonConstraint()
        setTopViewConstraint()
    }
    
    private func setNicknameLabelConstraint() {
        NSLayoutConstraint.activate([
            userNicknameLabel.topAnchor.constraint(equalTo: topAnchor),
            userNicknameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            userNicknameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            userNicknameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setLikeButtonConstraint() {
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setTopViewConstraint() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
}
