import Foundation
import UIKit

class CommentTableViewCell: UITableViewCell {
    // MARK: Properties
    static let identifier = "CommentTableViewCell"
    
    let commentView: CommentView = .init(frame: .zero)
    let sideSpaceConstant: CGFloat = 16
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .yellow
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: Configure
    private func configure() {
        setUI()
        setConstraint()
    }
    
    private func setUI(){
        self.contentView.addSubview(commentView)
        commentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            commentView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            commentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: sideSpaceConstant),
            commentView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -sideSpaceConstant),
            commentView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
}