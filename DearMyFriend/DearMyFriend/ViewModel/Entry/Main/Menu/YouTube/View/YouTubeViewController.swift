// 박철우-유튜브연결페이지
//
import Lottie
import SnapKit
import UIKit

class YouTubeViewController: UIViewController {
    private var youTubeviewModel = YouTubeViewModel()
    
    private let pageName = {
        let label = UILabel()
        label.text = "추천 유튜버"
        label.textColor = UIColor(named: "주요텍스트컬러")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    private let youtubeTableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "뷰컬러")
        tableView.isUserInteractionEnabled = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private let leftSide = {
        let newView = UIView()
        newView.frame = CGRect(x: 0, y: 0, width: 20, height: 908)
        newView.layer.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.4).cgColor
        return newView
    }()

    private let rightSide = {
        let newView = UIView()
        newView.frame = CGRect(x: 0, y: 0, width: 20, height: 908)
        newView.layer.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.4).cgColor
        return newView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "뷰컬러")
        // navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.hidesBackButton = true
        layoutForUI()
        layoutForSide()
        layoutForTableView()
        youtubeTableView.dataSource = self
        youtubeTableView.delegate = self
        youtubeTableView.register(YouTubeTableViewCell.self, forCellReuseIdentifier: "CellForYoutube")
    }
}

extension YouTubeViewController {
    
   private func layoutForUI() {
        for ui in [pageName] {
            view.addSubview(ui)
        }
        pageName.snp.makeConstraints { make in
            make.width.equalTo(139)
            make.height.equalTo(24)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(87)
        }
    }

   private func layoutForTableView() {
        view.addSubview(youtubeTableView)
        youtubeTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(180)
            make.bottom.equalToSuperview().offset(-49)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    private func layoutForSide() {
        for side in [leftSide, rightSide] {
            view.addSubview(side)
        }
        leftSide.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(908)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        rightSide.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(908)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}

extension YouTubeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youTubeviewModel.numberOfChannels()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForYoutube", for: indexPath) as! YouTubeTableViewCell

        let channel = youTubeviewModel.channel(at: indexPath.row)
        cell.youtubeImage.image = UIImage(named: channel.thumbnail)
           cell.youtubeName.text = channel.title
           cell.youtubeExplanation.text = channel.description

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChannel = youTubeviewModel.channel(at: indexPath.row)
        print("\(selectedChannel.title) 링크로 이동")
        let selectedLink = selectedChannel.link

        if let url = URL(string: selectedLink) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
