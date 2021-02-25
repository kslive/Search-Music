//
//  ArtistSearchViewController.swift
//  Search Music
//
//  Created by Eugene Kiselev on 25.02.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

let pageSize = 20

class ArtistSearchViewController: UIViewController {
    private let service: SearchServiceProtocol = SearchService()
    private let bag = DisposeBag()
    private let table = UITableView()
    private var isLoading = false
    private var section: SectionModel<String, Artist> = SectionModel(model: "", items: []) // так же необходимо хранить секцию
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTable()
        loadData()
    }
    
    private func setupTable() {
        view.addSubview(table)
        table.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Enter name of artist"
        navigationItem.titleView = searchBar
    }
    
    private func loadData() {
        let searchBarObservable = searchBar.rx.text.orEmpty
            .asObservable()
            .throttle(0.3, scheduler: MainScheduler.asyncInstance)
            .do { [weak self] _ in
                guard let self = self else { return }
                self.section.items = []
            }
        
        // пагинация
        let willDiplayCellObservable = table.rx.willDisplayCell.filter { [weak self] (_, indexPath) -> Bool in
            guard let self = self else { return  false }
            let numberOfRows = self.table.numberOfRows(inSection: 0)
            return (indexPath.row == numberOfRows - 1) && (numberOfRows % pageSize == 0) && self.isLoading // проверяем что это посл строка
        }.map { [weak self] _ in self?.searchBar.text ?? "" }
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Artist>>(configureCell: { (model, tableView, indexPath, artist) in
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
            cell.textLabel?.text = artist.artistName
            return cell
        })
        
        //объединяем
        Observable.merge([searchBarObservable, willDiplayCellObservable])
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isLoading = true
            })
            .flatMapLatest { [service] (searchString) -> Observable<ArtistResponse> in
                return service.artistList(searchString: searchString, limit: pageSize, offset: 0)
            }
            .asDriver(onErrorJustReturn: ArtistResponse(resultCount: 0, results: [Artist]()))
            .do(onNext: { [weak self] (_) in
                guard let self = self else { return }
                self.isLoading = false
            })
            .map { [weak self] response in
                guard let self = self else { return [] }
                self.section.items.append(contentsOf: response.results)
                return [self.section]
            }
            .drive(table.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        table.rx.modelSelected(Artist.self)
            .subscribe(onNext: { [weak self] artist in
                guard let self = self else { return }
                self.showArtist(artist)
            }).disposed(by: bag)
    }
    
    private func showArtist(_ artist: Artist) {
        let vc = ArtistDetailViewController()
        let router = ArtistDetailRouter(viewController: vc)
        let viewModel = ArtistDetailViewModel(router: router, artist: artist)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
