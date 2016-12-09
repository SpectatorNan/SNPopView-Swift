//
//  SNPooView.swift
//  SNPopView-Swift
//
//  Created by spectator Mr.Z on 2016/10/21.
//  Copyright © 2016年 spectator Mr.Z. All rights reserved.
//

import UIKit
import Foundation

//@objc(SNPopView)
 class SNPopView: UIView {
    var title: String?
//   lazy var contentArr: Array<Any> = { [unowned self] in
//    let result = self.dataSource?.snpopView(models: self)
//    return result!
//    }()
    
    var contentArr: Array<Any>?
    
    
    var delegate: SNPopViewDelegate?
    var dataSource: SNPopViewDataSource?
    var frameDelegate: SNPopViewFrameDelegate?
     var top: UIView?
//    fileprivate var mid: UIView?
     var bottom: UIView?

 
    
    convenience init() {
    self.init(frame: UIScreen.main.bounds)
        self.alpha = 0
        self.backgroundColor = UIColor(white: 0, alpha: 0.3)
    }
    
    func reloadContent() {
        table?.reloadData()
    }
    
    fileprivate var table: UITableView?
}


extension SNPopView {
    
    
    
    func popAlert(to:UIView, title: String?, content: Array<Any>) {
        self.title = title
//        self.contentArr = self.dataSource?.snpopView(models: self)
        self.contentArr = content
        to.addSubview(self)
        
        UIView.animate(withDuration: 0.4) { 
            self.alpha = 1
        }
        
        let width = snPopScreenWidth-40
        let height = snPopScreenHeight*0.3
        
        let contentView = UITableView()

        
         contentView.frame =  CGRect(x: 0, y: 0, width: width, height: height)
        
        let contentSuperView = UIView()
        contentSuperView.frame = adjustCenter(width: width, height: height)
        
        contentSuperView.addSubview(contentView)
        
        if let size = self.frameDelegate?.snpopViewSize(popView: self) {
//            contentView.frame.size = size
            contentView.frame = setFrameByCenter(width: size.width, height: size.height)
        }
        
        contentView.dataSource = self
        contentView.delegate = self
        contentView.alpha = 1
        contentView.backgroundColor = .white
        self.addSubview(contentSuperView)
        table = contentView
        
        if let headerView = self.delegate?.snpopView?(forHeader: self) {
            headerView.frame = setFrameOnTopOf(view: contentSuperView, height: headerView.frame.height)
            self.top = headerView
            
//            self.layoutIfNeeded()
            headerView.cornerByRoundingCorners(corners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8, height: 8))
            
            self.addSubview(headerView)
        } else {
          //MARK:  顶部圆角
            contentSuperView.cornerByRoundingCorners(corners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8, height: 8))
            
        }
        
        if let footerView = self.delegate?.snpopView?(forFooter: self) {
            footerView.frame = setFrameOnBottomOf(view: contentSuperView, height: footerView.frame.height)
            self.bottom = footerView
            
            footerView.cornerByRoundingCorners(corners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
            
            self.addSubview(footerView)
        } else {
            //MARK: 底部圆角
            if let _ = self.top {
                contentSuperView.cornerByRoundingCorners(corners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
            } else {
                contentSuperView.cornerByRoundingCorners(corners: .allCorners, cornerRadii: CGSize(width: 8, height: 8))
            }
        }
    }
    
     func dismiss() {
        

        UIView.animate(withDuration: 0.8, animations: {
            self.alpha = 0
            }) { (valid) in
                if valid {
//                    self.top?.removeFromSuperview()
//                    self.bottom?.removeFromSuperview()
                    
                    for subV in self.subviews {
                        subV.removeFromSuperview()
                    }
                    
                    self.table = nil
                    self.top = nil
                    self.bottom = nil
                    self.contentArr = nil
                    self.removeFromSuperview()
//                    self.alpha = 1
                    
                }
        }
    }
    
}


extension SNPopView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentArr!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dataSource?.snpopView(contentView: self, tableView: tableView, cellForRowAt: indexPath)
        return cell!
    }
    
}

extension SNPopView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.snpopView?(popView: self, didSelcted: tableView.cellForRow(at: indexPath)!, model: contentArr?[indexPath.row])
    }
    
}


let snPopScreenHeight = UIScreen.main.bounds.size.height
let snPopScreenWidth = UIScreen.main.bounds.size.width

extension UIView {
    
    func adjustCenter(width: CGFloat, height: CGFloat) -> CGRect {
        
        let centerX = self.superview?.center.x
        let centerY = self.superview?.center.y
        
        let x = centerX! - width/2
        let y = centerY! - height/2
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}


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

@objc protocol SNPopViewDelegate: NSObjectProtocol {
    
   @objc optional func snpopView(forFooter popView: SNPopView) -> UIView?
   @objc optional func snpopView(forHeader popView: SNPopView) -> UIView?
    @objc optional func snpopView(popView: SNPopView, didSelcted row:UITableViewCell,model rowModel: Any)
//    @objc optional func snpopView(forSize popView: SNPopView) -> CGRect?
 }

protocol SNPopViewFrameDelegate {
    func snpopViewSize(popView: SNPopView) -> CGSize?
}

protocol SNPopViewDataSource: NSObjectProtocol {
    func snpopView(contentView popView: SNPopView,tableView table: UITableView,  cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    func snpopView(models popView: SNPopView) -> Array<Any>
}

extension UIView {
    func cornerByRoundingCorners(corners: UIRectCorner, cornerRadii: CGSize) {
    let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
    let maskLayer = CAShapeLayer()
    maskLayer.frame = self.bounds
    maskLayer.path = maskPath.cgPath
    self.layer.mask = maskLayer
}
}
