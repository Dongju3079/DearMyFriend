//박철우 - 유튜브 셀 페이지

import Foundation
import Lottie
import SnapKit
import UIKit

class YouTubeTableViewCell: UITableViewCell {

    var youtubeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var youtubeName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "주요택스트컬러")
        return label
    }()
    
    var youtubeExplanation: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(named: "보조택스트컬러")
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(named: "셀컬러")
        layer.borderWidth = 1
        layer.cornerRadius = 10
   
        addSubview(youtubeImage)
        addSubview(youtubeName)
        addSubview(youtubeExplanation)
        
        youtubeImage.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        youtubeName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(youtubeImage.snp.trailing).offset(14)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        youtubeExplanation.snp.makeConstraints { make in
            make.top.equalTo(youtubeName.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalTo(youtubeImage.snp.trailing).offset(14)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        selectionStyle = .none
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "youtubeCell")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
