//
//  HeightAnalysis.swift
//  CellHeightAnalysis
//
//  Created by 11111 on 2017/7/12.
//  Copyright © 2017年 ZheJiang WanHang Mdt InfoTech CO.,Ltd. All rights reserved.
//

import UIKit

typealias cellConfigurationBlock = (_ cell : UITableViewCell) ->Void

struct runtimeKey {
    static var miKey : String = "misad"
    static var layoutCachekey : String = "layoutCachekey"
}

struct cellHeightCache {
    
    var mutableHeightsByKey : Dictionary<String,Box<CGFloat>>!
    
    init() {
        mutableHeightsByKey = [String : Box]()
    }
    
    
    func exitHeightCacheAt(givenKey : String) -> Bool {
        
        var exitState : Bool = false
        
        guard let height = mutableHeightsByKey[givenKey]?.outValue else {
            return exitState }
        
        if height > 0 {
            exitState = true
        }
        
        return exitState
    }
    
    mutating func cache(height : CGFloat,at key : String) {
        mutableHeightsByKey.updateValue(Box.init(value: height), forKey: key)
    }
    
    func heightCacheAt(givenKey : String) -> CGFloat {
        
        guard let height = mutableHeightsByKey[givenKey]?.outValue else {
            return 0 }
        
        return height
    }
    
    /// 清空全部缓存,数据源变更时需要调用
    mutating func invalidateAllHeightCaches() {
        mutableHeightsByKey.removeAll()
    }
    
    
    /// 清空某个高度缓存，数据源变更时需要调用
    ///
    /// - Parameter key: Key
    mutating func invalidateHeightCacheAt(key : String!) {
        mutableHeightsByKey.removeValue(forKey: key)
    }
}

extension UITableView{
    
    var heightCache : cellHeightCache {
        
        get{
            
            guard let cache = (objc_getAssociatedObject(self, &runtimeKey.miKey) as? Box<cellHeightCache>)?.outValue else {
                let innerCache = cellHeightCache.init()
                objc_setAssociatedObject(self,
                                         &runtimeKey.miKey,
                                         Box.init(value: innerCache),
                                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return innerCache }
            
            return cache

        }
    }
    
    
    func cellHeightCacheWith(identifier : String?,cacheKey : String?,configuration : cellConfigurationBlock) -> CGFloat {
        
        var height : CGFloat!
        var muHeightCache = heightCache
        
        guard let innerID = identifier,let innerkey = cacheKey else {
            return 0 }
        
        if muHeightCache.exitHeightCacheAt(givenKey: innerkey) {
            return muHeightCache.heightCacheAt(givenKey: innerkey)
        }
        
        let preLayoutCell : UITableViewCell = cellForReuse(identifier: innerID)
        preLayoutCell.prepareForReuse()
        configuration(preLayoutCell)
        
        height = fittingHeightFor(cell: preLayoutCell)
        muHeightCache.cache(height: height, at: cacheKey!)
        
        return height
    }
    
    private func cellForReuse(identifier : String!) -> UITableViewCell{
        
        var preLayoutCells : Dictionary<String,UITableViewCell>!
        
        if let innerCells = (objc_getAssociatedObject(self, &runtimeKey.layoutCachekey) as? Box<[String : UITableViewCell]>)?.outValue {
            preLayoutCells = innerCells
        }else{
            let initializeCells = [String : UITableViewCell]()
            preLayoutCells = initializeCells
        }
        
        guard let prelayoutCell = preLayoutCells[identifier] else {
            let innerCell = self.dequeueReusableCell(withIdentifier: identifier)
            innerCell?.contentView.translatesAutoresizingMaskIntoConstraints = true
            preLayoutCells.updateValue(innerCell!, forKey: identifier)
            
            objc_setAssociatedObject(self,
                                     &runtimeKey.layoutCachekey,
                                     Box.init(value: preLayoutCells),
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return innerCell! }
        
        objc_setAssociatedObject(self,
                                 &runtimeKey.layoutCachekey,
                                 Box.init(value: preLayoutCells),
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return prelayoutCell

    }
    
    private func fittingHeightFor(cell : UITableViewCell) -> CGFloat {
        var height : CGFloat = 0
        
        height = cell.contentView.frame.size.height
        
        return height
    }
}

class HeightAnalysis: NSObject {

}
