//
//  ThreadTableViewCell.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/16.
//

import UIKit
import SnapKit
import Then

final class ThreadTableViewCell: UITableViewCell, Identifiable {
    private let postTypeImageView = UIImageView().then {
        $0.image = .mailplugThread.badgeNotice
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let attachedImageView = UIImageView().then {
        $0.image = .mailplugThread.attached
    }
    
    private let newImageView = UIImageView().then {
        $0.image = .mailplugThread.newIcon
    }
    
    private let nametimeLabel = UILabel().then {
        $0.textColor = .lightGray
    }
    
    private let eyeImageView = UIImageView().then {
        $0.image = .mailplugThread.eye
    }
    
    private let viewCountLabel = UILabel().then {
        $0.text = "168"
        $0.textColor = .lightGray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(post: Post) {
        
        let postType = post.postType
        let title = post.title
        let attached: Bool = post.attachmentsCount < 1 ? false : true
        let isnewPost: Bool = post.isNewPost
        let writerName: String = post.writer.displayName
        let date: Date = post.createdDateTime.toDate()
        let viewCount: String = "\(post.viewCount)"
        

        switch postType {
        case .notice, .reply:
            let image: UIImage? = postType == .notice ? .mailplugThread.badgeNotice : .mailplugThread.badgeReply
            postTypeImageView.image = image
            
            postTypeImageView.snp.updateConstraints {
                $0.width.equalTo(image?.size.width ?? 0)
            }

        case .normal:
            postTypeImageView.image = nil
            
            postTypeImageView.snp.updateConstraints {
                $0.width.equalTo(0)
            }

        }
        
        let displayedDateString: String = {
            var string = ""
            
            let tar = date
            let cur = Date()
            
            let calendar = Calendar.current

            
            let curDateComponents = calendar.dateComponents([.year, .month, .day], from: cur)
            let tarDateComponents = calendar.dateComponents([.year, .month, .day], from: tar)
            let tarTimeFormatter = DateFormatter()
            
            if let curDay = curDateComponents.day, let tarDay = tarDateComponents.day {
                if curDay == tarDay {
                    // cur의 일자와 tar의 일자가 같을 경우
                    tarTimeFormatter.dateFormat = "HH:mm"
                    let tarTime = tarTimeFormatter.string(from: tar)
                    string = tarTime
                } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: cur), tar == yesterday {
                    // cur보다 tar의 일자가 1일 전인 경우
                    string = "어제"
                } else if let beforeYesterday = calendar.date(byAdding: .day, value: -2, to: cur), tar < beforeYesterday {
                    // cur보다 tar의 일자가 1일보다 전인 경우
                    tarTimeFormatter.dateFormat = "yy-MM-dd"
                    let tarFormattedDate = tarTimeFormatter.string(from: tar)
                    string = tarFormattedDate
                }
            }
            
            return string
        }()
        
        self.titleLabel.text = title
        self.attachedImageView.image = attached == false ? nil : .mailplugThread.attached
        self.newImageView.image = isnewPost == false ? nil : .mailplugThread.newIcon
        self.nametimeLabel.text = "\(writerName)∙\(displayedDateString)∙"
        self.viewCountLabel.text = viewCount
        
        self.layoutIfNeeded()
    }
    
    func layout() {
        contentView.addSubview(postTypeImageView)
        
        postTypeImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.top.equalToSuperview().offset(11)
            $0.height.equalTo(20)
            $0.width.equalTo(20)
        }
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(postTypeImageView.snp.trailing).offset(2)
            $0.centerY.equalTo(postTypeImageView)
            $0.trailing.lessThanOrEqualToSuperview().inset(34)
        }
        
        contentView.addSubview(attachedImageView)
        
        attachedImageView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(postTypeImageView)
            $0.height.width.equalTo(16)
        }
        
        contentView.addSubview(newImageView)
        
        newImageView.snp.makeConstraints {
            $0.leading.equalTo(attachedImageView.snp.trailing).offset(4)
            $0.centerY.equalTo(postTypeImageView)
            $0.width.equalTo(16)
            $0.height.equalTo(13)
        }
        
        contentView.addSubview(nametimeLabel)
        
        nametimeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.bottom.equalToSuperview().inset(11)
        }
        
        contentView.addSubview(eyeImageView)
        
        eyeImageView.snp.makeConstraints {
            $0.leading.equalTo(nametimeLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(nametimeLabel)
            $0.height.width.equalTo(16)
        }
        
        contentView.addSubview(viewCountLabel)
        
        viewCountLabel.snp.makeConstraints {
            $0.leading.equalTo(eyeImageView.snp.trailing).offset(2)
            $0.centerY.equalTo(nametimeLabel)
        }
        
    }
}
