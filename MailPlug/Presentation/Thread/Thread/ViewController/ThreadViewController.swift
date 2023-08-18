//
//  ThreadViewController.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class ThreadViewController: ViewController {
    
    struct Constants {
        static let titleFontSize = CGFloat(22)
    }
    
    // MARK: - Properties
    
    private let leftbarButton = UIButton().then {
        $0.setImage(.mailplugThread.hambergerMenu, for: .normal)
    }
    
    private let rightbarButton = UIButton().then {
        $0.setImage(.mailplugThread.magnifyingGlass, for: .normal)
    }

    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: Constants.titleFontSize)
    }
    
    private lazy var titleView = NavigationView()
    
    private let tableView = UITableView().then {
        $0.register(ThreadTableViewCell.self, forCellReuseIdentifier: ThreadTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.backgroundColor = .systemGray6
    }
    
    private let noPostImageView = UIImageView().then {
        $0.image = .mailplugThread.illust
        $0.isHidden = true
    }
    
    private let noPostLabel = UILabel().then {
        $0.text = "등록된 게시글이 없습니다."
        $0.textAlignment = .center
        $0.textColor = .lightGray
        $0.isHidden = true
    }
    
    let viewModel: ThreadViewModel
    private let scrollWillEnd = PublishSubject<Void>()
    let isInfinitedScroll = true
    
    // MARK: - inits
    
    init(viewModel: ThreadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setDelegate()
    }
    
    // MARK: - Binds
    
    override func bind() {
        let input = ThreadViewModel.Input(
            viewDidLoad: rx.viewWillAppear.take(1).map { _ in }.asObservable(),
            menuButtonTapped: leftbarButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            searchButtonTapped: rightbarButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            scrollWillEnd: scrollWillEnd
                .throttle(.seconds(3), scheduler: MainScheduler.asyncInstance)
        )
        
        let output = viewModel.transform(input: input)
        
        output.currentBoard
            .map { $0.displayName }
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.posts
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                
                if $0.isEmpty {
                    self.noPostImageView.isHidden = false
                    self.noPostLabel.isHidden = false
                } else {
                    self.noPostImageView.isHidden = true
                    self.noPostLabel.isHidden = true
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
    }
    
    // MARK: - Layout
    
    override func layout() {
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.addSubview(noPostImageView)
        
        noPostImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(178)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(152.62)
            $0.height.equalTo(160)
        }
        
        tableView.addSubview(noPostLabel)
        
        noPostLabel.snp.makeConstraints {
            $0.top.equalTo(noPostImageView.snp.bottom).offset(24)
            $0.centerX.equalTo(noPostImageView)
        }
    }
    
    private func setNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftbarButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightbarButton)
        
        titleView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        navigationItem.titleView = titleView
    }
    
    // MARK: - Methods
    
    func setDelegate() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension ThreadViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            if !viewModel.isLoading {
                scrollWillEnd.onNext(())
            }
        }
    }
}
