//
//  ViewController.swift
//  SNPopView-Swift
//
//  Created by spectator Mr.Z on 2016/10/21.
//  Copyright © 2016年 spectator Mr.Z. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func popAction(_ sender: AnyObject) {
        
        let pop = SNPopView()
        pop.dataSource = self
        pop.delegate = self
        pop.popAlert(to: self.view)
    }

}

extension ViewController: SNPopViewDataSource {
    
    func snpopView(models popView: SNPopView) -> Array<Any> {
        
        return ["1","2","3","4","5","6"]
    }
    
    func snpopView(contentView popView: SNPopView, tableView table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = table.dequeueReusableCell(withIdentifier: "popCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "popCell")
        }
        
        cell?.textLabel?.text = popView.contentArr[indexPath.row] as? String
        
        return cell!
    }
    
}

extension ViewController: SNPopViewDelegate {
    
    func snpopView(popView: SNPopView,didSelcted rowModel: Any) {
        print(rowModel)
        popView.dismiss()
    }
}
