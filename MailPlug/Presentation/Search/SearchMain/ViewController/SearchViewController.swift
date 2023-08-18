//
//  SearchController.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/17.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

final class SearchViewController: ViewController {
    
    // MARK: - Properties
    
    private let rightButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
    }
    
    let searchBar = SearchBar()
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .systemGray6
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    private let noRecentSearchImageView = UIImageView().then {
        $0.image = .mailplugThread.illustnoRecentSearch
        $0.isHidden = true
    }
    
    private let noRecentSearchLabel = UILabel().then {
        $0.text = "게시글의 제목, 내용 또는 작성자에게 포함된\n단어 또는 문장을 검색해주세요"
        $0.textAlignment = .center
        $0.textColor = .lightGray
        $0.isHidden = true
        $0.numberOfLines = 2
    }
    
    private let searchClass = BehaviorSubject<SearchClass>(value: .history)
    private let deleteButtonTapSubject = PublishSubject<(SearchClass, Search)>()
    
    let viewModel: SearchViewModel
    
    // MARK: - Inits
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        layoutNavigation()
    }
    
    // MARK: - bind
    
    override func bind() {
        
        bindSearchBar()
        
        let input = SearchViewModel.Input(
            cancleButtonTapped: rightButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            searchClass: searchClass,
            searchWord: searchBar.rx.text.compactMap { $0 }
                .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance),
            selectedSearch: tableView.rx.modelSelected((SearchClass, Search).self)
                .throttle(.seconds(1),latest: false, scheduler: MainScheduler.asyncInstance),
            deleteButton: deleteButtonTapSubject
                .throttle(.seconds(1),latest: false, scheduler: MainScheduler.asyncInstance)
        )
        
        let output = viewModel.transform(input: input)
        
        output.selectBoard
            .bind(to: searchBar.rx.placeholderBoard)
            .disposed(by: disposeBag)
        
        output.dataSource
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                
                if $0.isEmpty {
                    self.noRecentSearchImageView.isHidden = false
                    self.noRecentSearchLabel.isHidden = false
                } else {
                    self.noRecentSearchImageView.isHidden = true
                    self.noRecentSearchLabel.isHidden = true
                }
            })
            .drive(tableView.rx.items) { [weak self] tableView, index, item in
                guard let self = self,
                      let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as? SearchTableViewCell
                else { return UITableViewCell() }
                
                cell.configure(category: item.0, search: item.1)
                cell.selectionStyle = .none
                cell.deleteButtonTap
                    .bind(to: deleteButtonTapSubject)
                    .disposed(by: disposeBag)
                
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    func bindSearchBar() {
        searchBar.rx.text
            .compactMap { $0 }
            .map { $0.count > 0 ? .search : .history}
            .bind(to: searchClass)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    
    override func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(5)
        }
        
        tableView.addSubview(noRecentSearchImageView)
        
        noRecentSearchImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(178)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(110.92)
            $0.height.equalTo(172)
        }
        
        tableView.addSubview(noRecentSearchLabel)
        
        noRecentSearchLabel.snp.makeConstraints {
            $0.top.equalTo(noRecentSearchImageView.snp.bottom).offset(24)
            $0.centerX.equalTo(noRecentSearchImageView)
        }
    }
    
    private func layoutNavigation() {
        searchBar.snp.makeConstraints {
            $0.width.equalTo(view.frame.width - 18 - 6 - 18 - 30)
            $0.height.equalTo(40)
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
}
