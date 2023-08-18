//
//  MenuViewController.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Then
import SnapKit

struct Header {
    var category: String
}

struct SectionOfBoard {
    var header: Header
    var items: [Item]
}

extension SectionOfBoard: SectionModelType {
    typealias Item = Board
    
    init(original: SectionOfBoard, items: [Board]) {
        self = original
        self.items = items
    }
}

final class MenuViewController: ViewController {
    
    // MARK: - Properties
    
    private let leftButton = UIButton().then {
        $0.setImage(.mailplugThread.close, for: .normal)
    }
    
    private let menuCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.register(MenuCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MenuCollectionViewHeaderView.identifier)
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private let viewModel:  MenuViewModel
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfBoard>(
        configureCell: { dataSource, collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MenuCollectionViewCell.identifier,
                for: indexPath
            ) as? MenuCollectionViewCell else { return UICollectionViewCell() }

            cell.configure(board: item)
            return cell
        }, configureSupplementaryView: { dataSource, collectionView, _, indexPath in
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: MenuCollectionViewHeaderView.identifier,
                for: indexPath
            ) as? MenuCollectionViewHeaderView else { return UICollectionReusableView() }
                    
            header.configure(header: dataSource.sectionModels[indexPath.section].header)
            
            return header
        })
    
    // MARK: - Inits
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuCollectionView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    // MARK: - Bind
    
    override func bind() {
        let input = MenuViewModel.Input(
            closeButtonTapped: leftButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            viewDidLoad: rx.viewWillAppear.take(1).map { _ in }
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            selectBoard: menuCollectionView.rx.modelSelected(Board.self)
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )
        
        let output = viewModel.transform(input: input)
        
        output.tableViewDataSource
            .drive(menuCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    
    override func layout() {
        layoutNavigation()
        
        view.addSubview(menuCollectionView)
        
        menuCollectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func layoutNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = view.frame.width
        let itemHeight = CGFloat(48)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 48)
    }
}
