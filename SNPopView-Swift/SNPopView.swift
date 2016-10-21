//
//  SNPooView.swift
//  SNPopView-Swift
//
//  Created by spectator Mr.Z on 2016/10/21.
//  Copyright © 2016年 spectator Mr.Z. All rights reserved.
//

import UIKit

class SNPopView: UIView {
    
    var contentArr: Array<Any> {
        
        return (self.dataSource?.snpopView(models: self))!
    }
    
    var delegate: SNPopViewDelegate?
    var dataSource: SNPopViewDataSource?
    

 
    
    convenience init() {
    self.init(frame: UIScreen.main.bounds)
    
    self.backgroundColor = UIColor.lightGray
    self.alpha = 0.3
    }
    
   
    
    
}


extension SNPopView {
    
     func popAlert(to:UIView) {
        
//        let superView =  SNPopView(frame: UIScreen.main.bounds)
        to.addSubview(self)
        
        let width = snPopScreenWidth-40
        let height = snPopScreenHeight*0.3
        
        let contentView = UITableView(frame: setFrameByCenter(width: width, height: height))
        contentView.dataSource = self
        contentView.delegate = self
        self.addSubview(contentView)
        
        if let headerView = self.delegate?.snpopView?(forHeader: self) {
            headerView.frame = setFrameOnTopOf(view: contentView, height: headerView.frame.height)
            self.addSubview(headerView)
        }
        
        if let footerView = self.delegate?.snpopView?(forFooter: self) {
            footerView.frame = setFrameOnBottomOf(view: contentView, height: footerView.frame.height)
            self.addSubview(footerView)
        }
    }
    
     func dismiss() {
        
        self.removeFromSuperview()
    }
    
}


extension SNPopView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dataSource?.snpopView(contentView: self, tableView: tableView, cellForRowAt: indexPath)
        return cell!
    }
    
}

extension SNPopView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.snpopView?(popView: self,didSelcted: contentArr[indexPath.row])
    }
    
}


let snPopScreenHeight = UIScreen.main.bounds.size.height
let snPopScreenWidth = UIScreen.main.bounds.size.width

func setFrameByCenter(width:CGFloat, height:CGFloat) -> CGRect {
    
    let x = snPopScreenWidth/2 - (width)/2
    let y = snPopScreenHeight/2 - (height)/2
    
    return CGRect(x: x, y: y, width: width, height: height)
}

func setFrameOnTopOf(view:UIView, height: CGFloat) -> CGRect {
    
    let x = view.frame.origin.x
    let y = view.frame.origin.y - height
    
    return CGRect(x: x, y: y, width: view.frame.size.width, height: height)
}

func setFrameOnBottomOf(view:UIView, height: CGFloat) -> CGRect {
    
    let x = view.frame.origin.x
    let y = view.frame.origin.y + view.frame.size.height
    
    return CGRect(x: x, y: y, width: view.frame.size.width, height: height)
}

@objc protocol SNPopViewDelegate {
    
   @objc optional func snpopView(forFooter popView: SNPopView) -> UIView?
   @objc optional func snpopView(forHeader popView: SNPopView) -> UIView?
    @objc optional func snpopView(popView: SNPopView, didSelcted rowModel: Any)
 }

protocol SNPopViewDataSource {
    func snpopView(contentView popView: SNPopView,tableView table: UITableView,  cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func snpopView(models popView: SNPopView) -> Array<Any>
}
