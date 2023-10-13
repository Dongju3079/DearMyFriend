// FeadViewController
// Add Post View
// 게시글을 추가하는 화면

import Foundation
import UIKit

protocol AddPostViewDelegate: AnyObject {
    func imageViewTapped()
}

class AddPostView: UIView {
    
    // MARK: Properties
    // Label & Button
    let topViewHeight: CGFloat = 30
    let userNicknameLabelSize: CGFloat = 25
    let buttonSize: CGFloat = 20
    let buttonColor: UIColor = .black
    var delegate: AddPostViewDelegate?
    // Image
    let imageViewHeight: CGFloat = 300
    
    lazy var userNicknameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: userNicknameLabelSize)
        label.text = "사용자 닉네임" // 추후 파이어베이스로 받아온 사용자의 닉네임 표시
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var uploadPostButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("업로드", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: buttonSize)
        button.setTitleColor(buttonColor, for: .normal)
        
        return button
    }()
    
    lazy var cancelPostButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: buttonSize)
        button.setTitleColor(buttonColor, for: .normal)
        
        return button
    }()
    
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "spider1")

        return imageView
    }()
    
    lazy var imagePickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(profileImageViewTapped), for: .touchUpInside)
        return button
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
        [userNicknameLabel, uploadPostButton, cancelPostButton, postImageView, imagePickerButton].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setNicknameLabelConstraint()
        setCancelPostButtonConstraint()
        setAddPostButtonConstraint()
        setPostImageViewConstraint()
    }
    
    private func setNicknameLabelConstraint() {
        NSLayoutConstraint.activate([
            userNicknameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            userNicknameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            userNicknameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            userNicknameLabel.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
    
    private func setCancelPostButtonConstraint() {
        NSLayoutConstraint.activate([
            cancelPostButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cancelPostButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            cancelPostButton.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
    
    private func setAddPostButtonConstraint() {
        NSLayoutConstraint.activate([
            uploadPostButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            uploadPostButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            uploadPostButton.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
    
    private func setPostImageViewConstraint() {
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: userNicknameLabel.bottomAnchor, constant: 10),
            postImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: imageViewHeight),
            
            imagePickerButton.topAnchor.constraint(equalTo: postImageView.topAnchor),
            imagePickerButton.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor),
            imagePickerButton.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor),
            imagePickerButton.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor)
        ])
    }
    
    // MARK: - Action
    @objc private func profileImageViewTapped() {
        print("image 클릭")
        delegate?.imageViewTapped()
    }
}


