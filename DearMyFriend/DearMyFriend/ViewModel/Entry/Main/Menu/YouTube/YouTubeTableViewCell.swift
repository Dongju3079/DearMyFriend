
import Foundation
import Lottie
import SnapKit
import UIKit

// MARK: - 셀커스텀

class YouTubeTableViewCell: UITableViewCell {
    // MARK: - 셀에보여줄 항목

    var 유튜브체널이미지: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    var 유튜브체널라벨: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "일반택스트컬러")
        return label
    }()
    
    var 유튜브링크라벨: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(named: "일반택스트컬러")
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(named: "셀컬러")
        layer.borderWidth = 2
        layer.cornerRadius = 20
   
        addSubview(유튜브체널이미지)
        addSubview(유튜브체널라벨)
        addSubview(유튜브링크라벨)
        
        유튜브체널이미지.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(140)
        }
        
        유튜브체널라벨.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(유튜브체널이미지.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        유튜브링크라벨.snp.makeConstraints { make in
            make.top.equalTo(유튜브체널라벨.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalTo(유튜브체널이미지.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "youtubeCell")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
