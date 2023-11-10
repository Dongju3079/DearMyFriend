import Foundation
import UIKit

class MyFeedViewController: UIViewController {
    // MARK: Properties
    let myFeedView: FeedView = .init(frame: .zero)
    let index: Int
    
    // MARK: Initalizers
    init(index: Int){
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: Configure
    private func configure() {
        view.backgroundColor = .white

        setupMyFeedView()
    }
    
    private func setupMyFeedView() {
        view.addSubview(myFeedView)
        myFeedView.translatesAutoresizingMaskIntoConstraints = false
         
        NSLayoutConstraint.activate([
            myFeedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myFeedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            myFeedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}
