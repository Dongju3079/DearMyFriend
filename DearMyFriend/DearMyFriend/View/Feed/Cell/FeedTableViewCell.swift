// FeedViewController
// FeedTableViewCell
// Feed 화면에서 TableView에 들어갈 Cell
import Foundation
import UIKit

class FeedTableViewCell: UITableViewCell {
    // MARK: Properties
    static let identifier = "FeedTableViewCell"
    
    let feedView: FeedView = .init(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
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
        self.contentView.addSubview(feedView)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            feedView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            feedView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
}
