//
//  SearchResultViewController.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/18.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchResultViewController: ViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView().then {
        $0.register(ThreadTableViewCell.self, forCellReuseIdentifier: ThreadTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.backgroundColor = .systemGray6
    }
    
    private let rightButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
    }
    
    private let noSearchResultImageView = UIImageView().then {
        $0.image = .mailplugThread.illustnoSearchResult
        $0.isHidden = true
    }
    
    private let noResultLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다.\n다른 검색어를 입력해보세요."
        $0.textAlignment = .center
        $0.textColor = .lightGray
        $0.isHidden = true
        $0.numberOfLines = 0
    }
    
    let searchBar = SearchBar()
    
    let viewModel: SearchResultViewModel
    let searchClass = BehaviorSubject<SearchCategory>(value: .all)
    
    // MARK: - inits
    
    init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        layoutNavigation()
    }
    
    // MARK: - Bind
    
    override func bind() {
        
        let input = SearchResultViewModel.Input(
            viewDidLoad: rx.viewWillAppear.map { _ in }.take(1),
            rightButtonTapped: rightButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )
        
        let output = viewModel.transform(input: input)
        
        output.posts
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                if $0.isEmpty {
                    self.noSearchResultImageView.isHidden = false
                    self.noResultLabel.isHidden = false
                } else {
                    self.noSearchResultImageView.isHidden = true
                    self.noResultLabel.isHidden = true
                }
            })
            .drive(tableView.rx.items) { tableView, index, post in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ThreadTableViewCell.identifier) as? ThreadTableViewCell
                else { return UITableViewCell() }
                
                cell.configure(post: post)
                cell.selectionStyle = .none
                
                return cell
            }
            .disposed(by: disposeBag)
        
        output.search
            .bind(to: searchBar.rx.placeholderSearch)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    
    override func layout() {
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(5)
        }
        
        tableView.addSubview(noSearchResultImageView)
        
        noSearchResultImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(178)
            $0.centerX.equalToSuperview()
        }

        tableView.addSubview(noResultLabel)

        noResultLabel.snp.makeConstraints {
            $0.top.equalTo(noSearchResultImageView.snp.bottom).offset(24)
            $0.centerX.equalTo(noSearchResultImageView)
        }
    }
    
    private func layoutNavigation() {
        
        navigationItem.hidesBackButton = true
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        searchBar.snp.makeConstraints {
            $0.width.equalTo(view.frame.width - 18 - 6 - 18 - 30)
            $0.height.equalTo(40)
        }
    }
}
