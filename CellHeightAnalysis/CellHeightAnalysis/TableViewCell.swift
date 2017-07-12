//
//  TableViewCell.swift
//  CellHeightAnalysis
//
//  Created by 11111 on 2017/7/12.
//  Copyright © 2017年 ZheJiang WanHang Mdt InfoTech CO.,Ltd. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var heightCatch : CGFloat{
        get{
            return ViewHeight(v: cellView)
        }
        set{
            self.changedUI(height: newValue)
        }
    }
    
    
    private lazy var cellView: UIView = {
        let inner = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        inner.backgroundColor = ColorMethodho(hexValue: 0xb2b2b2)
        return inner
    }()
    
    func initUI() {
        self.backgroundColor = ColorMethodho(hexValue: 0xffffff)
        
    }
    
    private func changedUI(height : CGFloat) {
        
        let type = Int.init(height - 50) / 10
        print("height = \(height),type = \(type)")
        var cellBgColor : UIColor!
        
        switch type {
        case 1:
            cellBgColor = ColorMethodho(hexValue: 0x404040).withAlphaComponent(0.8)
            break
            
        case 2:
            cellBgColor = ColorMethodho(hexValue: 0x00c18b).withAlphaComponent(0.2)
            break
            
        case 3:
            cellBgColor = ColorMethodho(hexValue: 0xff4438).withAlphaComponent(0.2)
            break
            
        case 4:
            cellBgColor = ColorMethodho(hexValue: 0xb2b2b2)
            break
            
        case 5:
            cellBgColor = ColorMethodho(hexValue: 0x4990e2).withAlphaComponent(0.5)
            break
            
        case 6:
            cellBgColor = ColorMethodho(hexValue: 0xe6e6e6)
            break
            
        case 7:
            cellBgColor = ColorMethodho(hexValue: 0xd9d9d9)
            break
            
        default:
            cellBgColor = ColorMethodho(hexValue: 0xffffff)
        }
        
        self.contentView.backgroundColor = cellBgColor
        self.contentView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: height)
    }

}
