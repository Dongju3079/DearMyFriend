// 박철우-유튜브연결페이지

import Lottie
import SnapKit
import UIKit

// MARK: - Youtube추천 페이지

class YouTubeViewController: UIViewController {
    let youtubeData = DataForYoutube(thumbnail: "", title: "", description: "", link: "")

    private let 유튜브링크테이블뷰 = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "뷰컬러")
        tableView.isUserInteractionEnabled = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "뷰컬러")
        // navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        유튜브테이블뷰레이아웃()
        유튜브링크테이블뷰.dataSource = self
        유튜브링크테이블뷰.delegate = self
        유튜브링크테이블뷰.register(YouTubeTableViewCell.self, forCellReuseIdentifier: "CellForYoutube")
    }
}

// MARK: - ** EXTENSION **

//
//
//

// MARK: - 유아이 레이아웃

extension YouTubeViewController {
    func 유튜브테이블뷰레이아웃() {
        view.addSubview(유튜브링크테이블뷰)
        유튜브링크테이블뷰.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.bottom.equalToSuperview().offset(-50)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - 테이블뷰

extension YouTubeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        youtubeData.유튜브데이터.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForYoutube", for: indexPath) as! YouTubeTableViewCell

        let (thumbnail, title, description, link) = youtubeData.유튜브데이터[indexPath.row]
        cell.유튜브체널이미지.image = UIImage(named: thumbnail)
        cell.유튜브체널라벨.text = title
        cell.유튜브링크라벨.text = description

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(youtubeData.유튜브데이터[indexPath.row].title) 링크로 이동")
        let selectedLink = youtubeData.유튜브데이터[indexPath.row].link

        if let url = URL(string: selectedLink) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
