import Foundation
import UIKit

class AddPostViewController: UIViewController {
    
    // MARK: Properties
    let addPostView: AddPostView = .init(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        // NavigationBar 숨김.
//        navigationController?.isNavigationBarHidden = true
//    }
    
    // MARK: Configure
    private func configure() {
        view.backgroundColor = .white
        setupAddPostView()
    }
    
    private func setupAddPostView() {
        view.addSubview(addPostView)
        addPostView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addPostView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addPostView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addPostView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addPostView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
