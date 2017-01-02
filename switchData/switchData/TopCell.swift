//
//  TopCell.swift
//  tableViewData
//
//  Created by zhi zhou on 2017/1/1.
//  Copyright © 2017年 zhi zhou. All rights reserved.
//

import UIKit

class TopCell: UITableViewCell {
    
    var topImageView = UIImageView()
    
    let cellHeight: CGFloat = 200

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        topImageView = UIImageView(image: UIImage(named: "sh"))
        topImageView.contentMode = .scaleToFill
        topImageView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: cellHeight))
        contentView.addSubview(topImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
