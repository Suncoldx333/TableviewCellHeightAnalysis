//
//  learnMoreSwift.swift
//  LearnMore
//
//  Created by WangZhaoyun on 2017/5/21.
//  Copyright © 2017年 WangZhaoyun. All rights reserved.
//

import UIKit

struct cellHeightCache {
    
    var mutableHeightsByKey : NSMutableDictionary!
    
    init() {
        mutableHeightsByKey = NSMutableDictionary.init()
    }
    
    
    func exitHeightCacheAt(givenKey : String) -> Bool {
        
        let height : NSNumber? = mutableHeightsByKey.object(forKey: givenKey) as? NSNumber
        var exitState : Bool = false
        if height != nil && height!.floatValue != -1 {
            exitState = true
        }
        
        return exitState
    }
    
    func cache(height : CGFloat,AtKey : String) {
        mutableHeightsByKey.setObject(NSNumber.init(value: Float.init(height)), forKey: AtKey as NSCopying)
    }
    
    func heightCacheAt(givenKey : String) -> CGFloat {
        let heightNum : NSNumber = mutableHeightsByKey.object(forKey: givenKey) as! NSNumber
        let height : CGFloat = CGFloat.init(heightNum)
        
        return height
    }
    
    
    /// 清空全部缓存,数据源变更时需要调用
    func invalidateAllHeightCaches() {
        mutableHeightsByKey.removeAllObjects()
    }
    
    
    /// 清空某个高度缓存，数据源变更时需要调用
    ///
    /// - Parameter key: Key
    func invalidateHeightCacheAt(key : String!) {
        mutableHeightsByKey.removeObject(forKey: key)
    }
}

struct runtimeKey {
    static var miKey : String = "misad"
}

typealias cellConfigurationBlock = (UITableViewCell) ->Void

extension UITableView{
    
    var heightCache : cellHeightCache! {
        
        get{
            var cache : cellHeightCache? = objc_getAssociatedObject(self, &runtimeKey.miKey) as? cellHeightCache
            if cache == nil {
                cache = cellHeightCache.init()
                objc_setAssociatedObject(self, &runtimeKey.miKey, cache!, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            return cache
        }
    }
    
    
    func cellHeightCacheWith(identifier : String?,cacheKey : String?,configuration : cellConfigurationBlock) -> CGFloat {
        
        var height : CGFloat = 0
        
        if identifier == nil || cacheKey == nil {
            return height
        }
        
        if self.heightCache.exitHeightCacheAt(givenKey: cacheKey!) {
            return self.heightCache.heightCacheAt(givenKey: cacheKey!)
        }
        
        let preLayoutCell : UITableViewCell = cellForReuse(identifier: identifier)
        preLayoutCell.prepareForReuse()
        configuration(preLayoutCell)
        
        height = fittingHeightFor(cell: preLayoutCell)
        self.heightCache.cache(height: height, AtKey: cacheKey!)
        return height
    }
    
    private func cellForReuse(identifier : String?) -> UITableViewCell{
        
        let layouyCachekey : String = "layouyCache"
        
        var preLayoutCellByIdentifiers : [String : UITableViewCell]? = objc_getAssociatedObject(self, layouyCachekey) as? [String : UITableViewCell]
        if preLayoutCellByIdentifiers == nil {
            preLayoutCellByIdentifiers = [:]
            objc_setAssociatedObject(self, layouyCachekey, preLayoutCellByIdentifiers, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        var preLayoutCell : UITableViewCell? = preLayoutCellByIdentifiers?[identifier!]
        if preLayoutCell == nil {
            preLayoutCell = self.dequeueReusableCell(withIdentifier: identifier!)
            preLayoutCell?.contentView.translatesAutoresizingMaskIntoConstraints = true
            preLayoutCellByIdentifiers?.updateValue(preLayoutCell!, forKey: identifier!)
        }
        
        return preLayoutCell!
    }
    
    private func fittingHeightFor(cell : UITableViewCell) -> CGFloat {
        var height : CGFloat = 0
        
        height = cell.contentView.frame.size.height
        
        return height
    }
}

class learnMoreSwift: NSObject {

}
