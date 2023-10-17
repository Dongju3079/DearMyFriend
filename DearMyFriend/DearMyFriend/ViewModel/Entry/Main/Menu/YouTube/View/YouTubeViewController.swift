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
        tableView.separatorStyle = .none

        return tableView
    }()

    private let leftSide = {
        let side = UIView()
        side.frame = CGRect(x: 0, y: 0, width: 20, height: 908)
        side.layer.backgroundColor = UIColor(named: "보더컬러")?.cgColor
        return side
    }()

    private let rightSide = {
        let side = UIView()
        side.frame = CGRect(x: 0, y: 0, width: 20, height: 908)
        side.layer.backgroundColor = UIColor(named: "보더컬러")?.cgColor
        return side
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
            make.top.equalToSuperview().offset(200)
            make.bottom.equalToSuperview().offset(-49)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "냥냥이 채널"
        } else if section == 1 {
            return "댕댕이 채널"
        }
        return nil
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor(named: "뷰컬러")
            headerView.textLabel?.textColor = UIColor(named: "주요택스트컬러")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youTubeviewModel.numberOfChannels(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForYoutube", for: indexPath) as! YouTubeTableViewCell

        let youtubeChannel = youTubeviewModel.channel(at: indexPath)
        cell.youtubeImage.image = UIImage(named: youtubeChannel.thumbnail)
        cell.youtubeName.text = youtubeChannel.title
        cell.youtubeExplanation.text = youtubeChannel.description
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChannel = youTubeviewModel.channel(at: indexPath)
        print("\(selectedChannel.title) 링크로 이동")
        let selectedLink = selectedChannel.link

        if let url = URL(string: selectedLink) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
