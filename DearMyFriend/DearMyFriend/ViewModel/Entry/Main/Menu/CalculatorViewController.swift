// 박철우-계산기페이지

import Lottie
import SnapKit
import UIKit

class CalculatorViewController: UIViewController {
    // MARK: - 유 아 이

    private let 페이지제목 = {
        let label = UILabel()

        label.text = "사료 칼로리 계산기"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "일반택스트컬러")

        return label
    }()

    private let 사료그람입력 = {
        let textField = UITextField()
        textField.placeholder = "사료 g (를)을 입력해주세요 !"
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor(named: "텍스트컬러")
        textField.backgroundColor = UIColor(named: "")
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.tintColor = .magenta
        textField.clearButtonMode = .whileEditing
        textField.clearsOnBeginEditing = true
        return textField
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "급여량 계산기"
        //계산기화면레이아웃()
    }

    func 계산기화면레이아웃() {
        for 계산기유아이 in [사료그람입력] {
            view.addSubview(계산기유아이)
        }

        사료그람입력.snp.makeConstraints { make in
//            make.top.equalTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
//            make.bottom.equalTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
//            make.leading.equalTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
//            make.trailing.equalTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
    }
}
