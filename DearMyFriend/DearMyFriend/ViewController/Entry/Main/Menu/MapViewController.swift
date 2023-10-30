import UIKit
import NMapsMap
import CoreLocation
import Moya
import SnapKit

class MapViewController: UIViewController {
    var selectedItem: Item?

    var locationManager = CLLocationManager()
    var naverMapView: NMFNaverMapView?
    let geocoder = CLGeocoder()
    var searchResults: [(title: String, roadAddress: String)] = []
    let naverSearch = MoyaProvider<NaverSearchService>()
    let SearchResultCell = "SearchResultCell"
    var markers: [NMFMarker] = []

    var searchResultsTableView: UITableView = UITableView()
    var searchController: UISearchController!
    var searchResultsTableViewController: UITableViewController!
    var recentSearches: [String] = []

    private lazy var showAnimalHospitalButton: UIButton = {
        let button = createStyledButton(title: "동물병원")
        button.addTarget(self, action: #selector(showAnimalHospital), for: .touchUpInside)
        return button
    }()

    private lazy var showPetShopsButton: UIButton = {
        let button = createStyledButton(title: "펫샵")
        button.addTarget(self, action: #selector(showPetShop), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: SearchResultCell)

        naverMapView = NMFNaverMapView(frame: self.view.frame)
        naverMapView?.showLocationButton = true
        naverMapView?.mapView.isScrollGestureEnabled = true

        if let naverMapView = naverMapView {
            self.view.addSubview(naverMapView)
        }

        setupButtonLayout()
        setupLocationManager()
        setupSearchController()
        addTableView()
    }

    private func createStyledButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .yellow
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return button
    }

    private func setupButtonLayout() {
        view.addSubview(showAnimalHospitalButton)
        view.addSubview(showPetShopsButton)

        showAnimalHospitalButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(12)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }

        showPetShopsButton.snp.makeConstraints {
            $0.top.equalTo(showAnimalHospitalButton)
            $0.leading.equalTo(showAnimalHospitalButton).offset(112)
            $0.width.equalTo(showAnimalHospitalButton)
            $0.height.equalTo(showAnimalHospitalButton)
        }

        showAnimalHospitalButton.layer.cornerRadius = 10
        showPetShopsButton.layer.cornerRadius = 10
    }

    func setupLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

        if CLLocationManager.locationServicesEnabled() {
            let status = self.locationManager.authorizationStatus
            if status == .notDetermined {
                self.locationManager.requestWhenInUseAuthorization()
            } else if status == .authorizedWhenInUse || status == .authorizedAlways {
                DispatchQueue.main.async {
                    self.locationManager.startUpdatingLocation()
                }
            }
        } else {
            print("위치 서비스가 활성화되어 있지 않습니다.")
        }
    }

    func setupSearchController() {
        searchResultsTableViewController = UITableViewController(style: .plain)
        searchResultsTableViewController.tableView = searchResultsTableView
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self

        searchController = UISearchController(searchResultsController: searchResultsTableViewController)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "검색할 위치를 입력하세요"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func addTableView() {
        searchResultsTableView.frame = view.bounds
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        view.addSubview(searchResultsTableView)
    }

    func handleSearchResults(_ results: [(title: String, roadAddress: String)]) {
        searchResults = results
        searchResultsTableView.reloadData()
    }

    @objc func showAnimalHospital() {
        searchLocalPlaces("동물병원")
    }

    @objc func showPetShop() {
        searchLocalPlaces("애완동물 용품점")
    }
}

// MARK: - CLLocationManagerDelegate Extension
extension MapViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        } else {
            print("위치 권한이 부여되지 않았습니다.")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                print("현재 위치: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                self.addMarker(at: location.coordinate, title: "현재위치요~")
            }
        }
    }
}

// MARK: - UISearchBarDelegate Extension
extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        if let searchText = searchBar.text {
            geocoder.geocodeAddressString(searchText) { [weak self] placemarks, error in
                if let placemark = placemarks?.first, let location = placemark.location {
                    let coordinate = location.coordinate
                    self?.addMarker(at: coordinate, title: searchText)
                }
            }
        }
    }
    func addMarker(at coordinate: CLLocationCoordinate2D, title: String) {
        guard let mapView = naverMapView?.mapView else {
            return
        }

        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        marker.mapView = mapView
        marker.captionText = title

        markers.append(marker)
    }
}
extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count + recentSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)

        if indexPath.row < recentSearches.count {
            cell.textLabel?.text = recentSearches[indexPath.row]
        } else {
            cell.textLabel?.text = searchResults[indexPath.row - recentSearches.count]
            if let item = searchResults[indexPath.row - recentSearches.count] as? Item {
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = item.roadAddress // 로드 어드레스 추가
            }
        }
        return cell
    }
    func distanceToLocation(_ mapy: String, _ mapx: String) -> String {
        guard let currentLatitude = locationManager.location?.coordinate.latitude,
              let currentLongitude = locationManager.location?.coordinate.longitude,
              let targetLatitude = Double(mapy),
              let targetLongitude = Double(mapx) else {
            return "알 수 없음"
        }

        let currentLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        let targetLocation = CLLocation(latitude: targetLatitude, longitude: targetLongitude)

        let distanceInMeters = currentLocation.distance(from: targetLocation)
        return String(format: "%.2f", distanceInMeters)

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("###:)",searchResults)


        if indexPath.row < recentSearches.count {
            let selectedSearch = recentSearches[indexPath.row]
            geocoder.geocodeAddressString(selectedSearch) { [weak self] placemarks, error in
                if let placemark = placemarks?.first, let location = placemark.location {
                    let coordinate = location.coordinate
//                    self?.moveMapToLocation(coordinate)
//                    self?.searchResultsTableView.isHidden = true
                    print("###:)",selectedSearch)
                }
                    self?.moveMapToLocation(coordinate)
                    self?.searchResultsTableView.isHidden = true
                    print("###:)",selectedSearch)
                }
            }
        } else {
            let selectedItem = searchResults[indexPath.row - recentSearches.count]
            if let item = selectedItem as? Item, let roadAddress = item.roadAddress {
                searchLocationWithAddress(roadAddress)
            }
        }
        
    }
    func moveMapToLocation(_ coordinate: CLLocationCoordinate2D) {
        print("Moving to coordinate: \(coordinate.latitude), \(coordinate.longitude)")

        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(from: coordinate))
        if let mapView = naverMapView?.mapView {
            mapView.moveCamera(cameraUpdate)
        }

        if let selectedItem = selectedItem {
            let cleanTitle = selectedItem.cleanTitle()
            addMarker(at: coordinate, title: cleanTitle)
        }

        if !searchResults.isEmpty {
            searchResultsTableView.isHidden = true
        }

    }
}
extension MapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
=======
    @objc private func delayedSearch(_ searchController: UISearchController) {
>>>>>>> c789a61 ([FIX] 검색어 입력시 딜레이 추가 텍스트입력될때마다 이동하거나 마커가 추가되는 버그 수정)
        if let searchText = searchController.searchBar.text {
            searchLocalPlaces(searchText)
        }
    }
}

    // MARK: - CLLocationManagerDelegate Extension
    extension MapViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                DispatchQueue.main.async {
                    print("현재 위치: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                    self.addMarker(at: location.coordinate, title: "현재위치요~")
                }
            }
        }
    }

    // MARK: - UISearchBarDelegate Extension
    extension MapViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()

            if let searchText = searchBar.text {
                searchLocalPlaces(searchText)
            }
        }

        func addMarker(at coordinate: CLLocationCoordinate2D, title: String) {
            guard let mapView = naverMapView?.mapView else {
                return
            }

            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
            marker.mapView = mapView
            marker.captionText = title

            markers.append(marker)
        }
    }

    extension MapViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return searchResults.count + recentSearches.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: SearchResultCell)

                   if indexPath.row < recentSearches.count {
                       cell.textLabel?.text = recentSearches[indexPath.row]
                   } else {
                       let resultIndex = indexPath.row - recentSearches.count
                       let resultItem = searchResults[resultIndex]
                       cell.textLabel?.text = resultItem.title

                       // Add road address to detailTextLabel
                       cell.detailTextLabel?.text = resultItem.roadAddress
                   }

                   return cell
               }


        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.row < recentSearches.count {
                let selectedSearch = recentSearches[indexPath.row]
                geocoder.geocodeAddressString(selectedSearch) { [weak self] placemarks, error in
                    if let placemark = placemarks?.first, let location = placemark.location {
                        self?.moveMapToLocation(location.coordinate)
                        self?.addMarker(at: location.coordinate, title:selectedSearch )
                    }
                }
            } else {
                let resultIndex = indexPath.row - recentSearches.count
                let selectedResultItem  = searchResults[resultIndex]


                geocoder.geocodeAddressString(selectedResultItem.roadAddress) { [weak self] placemarks, error in
                    if let placemark = placemarks?.first, let location = placemark.location {
                        self?.moveMapToLocation(location.coordinate)
                        self?.addMarker(at: location.coordinate, title:selectedResultItem.title )
                    }
                }
            }
        }

        func moveMapToLocation(_ coordinate: CLLocationCoordinate2D) {
            print("Moving to coordinate: \(coordinate.latitude), \(coordinate.longitude)")

            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(from: coordinate))
            if let mapView = naverMapView?.mapView {
                mapView.moveCamera(cameraUpdate)
            }

            if let selectedItem = selectedItem {
                let cleanTitle = selectedItem.cleanTitle()
                addMarker(at: coordinate, title: cleanTitle)
            }

            //        if !searchResults.isEmpty {
            searchResultsTableView.isHidden = true
        }
    }

    extension MapViewController: UISearchResultsUpdating {
        func updateSearchResults(for searchController: UISearchController) {
            guard let searchText = searchController.searchBar.text,
                  !searchText.isEmpty else { return }

            NSObject.cancelPreviousPerformRequests(withTarget: self,
                                                   selector: #selector(delayedSearch(_:)),
                                                   object: searchController)

            perform(#selector(delayedSearch(_:)), with: searchController, afterDelay: 0.2)
        }



        func searchLocalPlaces(_ query: String) {
            naverSearch.request(.search(query: query)) { [weak self] result in
                switch result {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        let results = try decoder.decode(Welcome.self, from: response.data)
                        var searchResultsWithAddresses: [(title: String, roadAddress: String)] = []


                        if let mapView = self?.naverMapView?.mapView {
                            for item in results.items {
                                let title = item.title
                                let phoneNumber = item.telephone

                                var roadAddress: String? = item.roadAddress

                                if let roadAddress = roadAddress {
                                    print("Title: \(title), roadAddress: \(roadAddress), phoneNumber: \(phoneNumber)")

                                    self?.searchLocationWithAddress(roadAddress)
                                    self?.selectedItem = item
                                } else {
                                    let alertController = UIAlertController(title: "주소를 찾을 수 없습니다", message: "해당 장소의 주소 정보를 찾을 수 없습니다.", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                                    alertController.addAction(okAction)
                                    self?.present(alertController, animated: true, completion: nil)
                                }
                            }
                        }

                        if let self = self {
                            let placeInfos = results.items.map { (title: $0.cleanTitle(), roadAddress: $0.roadAddress ?? "") }
                            self.handleSearchResults(placeInfos)
                        }
                    } catch {
                        print("JSON decoding error: \(error)")
                    }
                case .failure(let error):
                    print("Network request error: \(error)")
                }
            }
        }
    }

    extension MapViewController {
        func searchLocationWithAddress(_ address: String) {
            print("###:)", address)
            geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
                if let placemark = placemarks?.first, let location = placemark.location {
                    let coordinate = location.coordinate
                    self?.moveMapToLocation(coordinate)
                } else {
                    print("주소를 찿을수 없어예")
                }
            }
        }
    }
