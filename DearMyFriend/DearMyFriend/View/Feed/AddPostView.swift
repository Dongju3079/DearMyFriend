// FeadViewController
// Add Post View
// 게시글을 추가하는 화면

import Foundation
import UIKit

protocol AddPostViewDelegate: AnyObject {
    func cancelButtonTapped()
    func uploadButtonTapped()
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
    let imageViewHeight: CGFloat = 500
    let imageName: String = "spider1"
    // TextView
    let postTextViewHeight: CGFloat = 100
    
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
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var cancelPostButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: buttonSize)
        button.setTitleColor(buttonColor, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: imageName)

        return imageView
    }()
    
    lazy var imagePickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(profileImageViewTapped), for: .touchUpInside)
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
        [userNicknameLabel, uploadPostButton, cancelPostButton, postImageView, imagePickerButton, postTextView].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setNicknameLabelConstraint()
        setCancelPostButtonConstraint()
        setAddPostButtonConstraint()
        setPostImageViewConstraint()
        setPostTextViewConstraint()
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
            postImageView.topAnchor.constraint(equalTo: userNicknameLabel.bottomAnchor),
            postImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: imageViewHeight),
            
            imagePickerButton.topAnchor.constraint(equalTo: postImageView.topAnchor),
            imagePickerButton.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor),
            imagePickerButton.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor),
            imagePickerButton.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor)
        ])
    }
    
    private func setPostTextViewConstraint() {
        NSLayoutConstraint.activate([
            postTextView.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            postTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            postTextView.heightAnchor.constraint(equalToConstant: postTextViewHeight)
        ])
    }
    
    // MARK: - Action
    @objc private func cancelButtonTapped(){
        print("cancel 클릭")
        delegate?.cancelButtonTapped()
    }
    @objc private func uploadButtonTapped(){
        print("upload 클릭")
        delegate?.uploadButtonTapped()
    }
    
    @objc private func profileImageViewTapped(){
        print("image 클릭")
        delegate?.imageViewTapped()
    }
}


