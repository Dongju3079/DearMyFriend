// 박철우-유튜브연결페이지

import Lottie
import SnapKit
import UIKit

// MARK: - Youtube추천 페이지

class YouTubeViewController: UIViewController {
    let youtubeData = DataForYoutube(thumbnail: "", title: "", description: "", link: "")

    private let 페이지이름 = {
        let label = UILabel()
        label.text = "추천 유튜버"
        label.textColor = UIColor(named: "텍스트컬러")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    private let 유튜브링크테이블뷰 = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "뷰컬러")
        tableView.isUserInteractionEnabled = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private let 왼쪽사이드 = {
        let newView = UIView()
        newView.frame = CGRect(x: 0, y: 0, width: 20, height: 908)
        newView.layer.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.4).cgColor
        return newView
    }()

    private let 오른쪽사이드 = {
        let newView = UIView()
        newView.frame = CGRect(x: 0, y: 0, width: 20, height: 908)
        newView.layer.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.4).cgColor
        return newView
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "뷰컬러")
        // navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.hidesBackButton = true
        유아이레이아웃()
        사이드레이아웃()
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
    //
    func 유아이레이아웃() {
        for 유아이 in [페이지이름] {
            view.addSubview(유아이)
        }
        페이지이름.snp.makeConstraints { make in
            make.width.equalTo(139)
            make.height.equalTo(24)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(87)
        }
    }

    func 유튜브테이블뷰레이아웃() {
        view.addSubview(유튜브링크테이블뷰)
        유튜브링크테이블뷰.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(155)
            make.bottom.equalToSuperview().offset(-49)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    func 사이드레이아웃() {
        for 사이드 in [왼쪽사이드, 오른쪽사이드] {
            view.addSubview(사이드)
        }
        왼쪽사이드.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(908)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        오른쪽사이드.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(908)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
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
