//
//  HomePageViewController.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import CoreLocation

enum ViewState {
    case loading
    case success
    case failure(errorMessage: String)
}

protocol HomePageViewProtocol: AnyObject {
    func changeViewState(_ viewState: ViewState)
    func setupSearchBar()
    func setupTableView()
    func setupActivityIndicator()
    func setupGeoLocation()
    func endSearchBarEditing()
    func showActivityIndicator(_ shouldShow: Bool)
}

final class HomePageViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var informationView: UIView!
    @IBOutlet private weak var seperatorView: UIView!
    @IBOutlet private weak var locationNameLabel: UILabel!
    @IBOutlet private weak var locationWeatherInformationLabel: UILabel!
    @IBOutlet private weak var weatherSitatuationImageView: UIImageView!
    @IBOutlet private weak var currentTemperatureLabel: UILabel!
    @IBOutlet private weak var lowTemperatureLabel: UILabel!
    @IBOutlet private weak var highTemperatureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var resultTableView: UITableView!
    
    // MARK: Private properties
    private let locationManager: CLLocationManager = CLLocationManager()
    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    // MARK: Internal properties
    let presenter: HomePagePresenterProtocol
    
    // MARK: Initializers
    init(presenter: HomePagePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: .main)
    }
    
    
    convenience init(someShit: HomePagePresenterProtocol) {
        self.init(presenter: someShit)

    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension HomePageViewController: HomePageViewProtocol {
    
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
    }
    
    func setupTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
        
        resultTableView.register(UINib(nibName: WeatherInformationUITableViewCell.ReuseIdentifier, bundle: Bundle.main), forCellReuseIdentifier: WeatherInformationUITableViewCell.ReuseIdentifier)
    }
    
    func changeViewState(_ viewState: ViewState) {
        switch viewState {
        case .loading:
            searchBar.isHidden = true
            informationView.isHidden = true
            resultTableView.isHidden = true
            seperatorView.isHidden = true
        case .success:
            searchBar.isHidden = false
            informationView.isHidden = false
            resultTableView.isHidden = false
            seperatorView.isHidden = false
            self.setupWithSuccess()
        case .failure(let errorMessage):
            searchBar.isHidden = false
            informationView.isHidden = true
            resultTableView.isHidden = true
            seperatorView.isHidden = true
            self.showToast(message: errorMessage, font: .systemFont(ofSize: 12))
        }
    }
    
    func setupGeoLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100.0
        locationManager.delegate = self
    }
    
    func endSearchBarEditing() {
        searchBar.endEditing(true)
    }
    
    private func setupWithSuccess() {
        resultTableView.reloadData()
        locationNameLabel.text = presenter.cityName
        weatherSitatuationImageView.image = UIImage(named: presenter.weatherInformationList.first?.first?.weather.first?.icon ?? "01d")
        locationWeatherInformationLabel.text = presenter.weatherInformationList.first?.first?.weather.first?.main ?? "NA"
        currentTemperatureLabel.text = "\(presenter.weatherInformationList.first?.first?.main.temp.rounded() ?? 0)"
        lowTemperatureLabel.text = "\(presenter.weatherInformationList.first?.first?.main.temp_min.rounded() ?? 0)"
        highTemperatureLabel.text = "\(presenter.weatherInformationList.first?.first?.main.temp_max.rounded() ?? 0)"
        humidityLabel.text = "\(presenter.weatherInformationList.first?.first?.main.humidity.rounded() ?? 0)"
    }
    
    func showActivityIndicator(_ shouldShow: Bool) {
        shouldShow ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

extension HomePageViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.didSearchBarSearchButtonClicked(cityName: searchBar.text ?? "")
    }
}

extension HomePageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 2.2
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        presenter.scrollViewDidScroll()
    }
}

extension HomePageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.weatherInformationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : WeatherInformationUITableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherInformationUITableViewCell.ReuseIdentifier, for : indexPath) as? WeatherInformationUITableViewCell else {
            return UITableViewCell()
        }
        
        cell.informationModel = presenter.weatherInformationList[indexPath.row]
        return cell
    }
}

extension HomePageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            presenter.didUpdateLocations(latitude: location.coordinate.latitude.magnitude, longitude: location.coordinate.longitude.magnitude)
        }
    }
}

extension WeakRef: HomePageViewProtocol where T: HomePageViewProtocol {

    func changeViewState(_ viewState: ViewState) {
        object?.changeViewState(viewState)
    }
    
    func setupSearchBar() {
        object?.setupSearchBar()
    }
    
    func setupTableView() {
        object?.setupTableView()
    }
    
    func setupActivityIndicator() {
        object?.setupActivityIndicator()
    }
    
    func setupGeoLocation() {
        object?.setupGeoLocation()
    }
    
    func endSearchBarEditing() {
        object?.endSearchBarEditing()
    }
    
    func showActivityIndicator(_ shouldShow: Bool) {
        object?.showActivityIndicator(shouldShow)
    }
}
