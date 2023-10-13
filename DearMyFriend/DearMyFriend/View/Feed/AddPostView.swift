// FeadViewController
// Add Post View
// 게시글을 추가하는 화면

import Foundation
import UIKit

class AddPostView: UIView {
    
    // MARK: Properties
    // Label & Button
    let topViewHeight: CGFloat = 30
    let userNicknameLabelSize: CGFloat = 15
    let buttonSize: CGFloat = 20
    let buttonColor: UIColor = .black
    
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
        
        button.setTitle("업로드", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: buttonSize)
        button.setTitleColor(buttonColor, for: .normal)
        
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
        [userNicknameLabel, uploadPostButton, cancelPostButton].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setNicknameLabelConstraint()
        setAddPostButtonConstraint()
    }
    
    private func setNicknameLabelConstraint() {
        NSLayoutConstraint.activate([
            userNicknameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            userNicknameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            userNicknameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            userNicknameLabel.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
    
    private func setAddPostButtonConstraint() {
        NSLayoutConstraint.activate([
            uploadPostButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            uploadPostButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            uploadPostButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            uploadPostButton.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
    
    private func setCancelPostButtonConstraint() {
        NSLayoutConstraint.activate([
            cancelPostButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cancelPostButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            cancelPostButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            cancelPostButton.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
}
