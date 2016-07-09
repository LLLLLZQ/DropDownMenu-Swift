//
//  ViewController.swift
//  Menu-Swift
//
//  Created by LZQ on 16/5/26.
//  Copyright © 2016年 LZQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let titleArr = ["第一栏","第二栏","第三栏"]
    
    let data1 = ["第一栏第一项","第一栏第二项","第一栏第三项","第一栏第四项"]
    let data2 = ["第二栏第一项","第二栏第二项","第二栏第三项"]
    let data3 = ["第三栏第一项","第三栏第二项","第三栏第三项"]
    
    var firstSelectedIndex: Int = 0
    var secondSelectedIndex: Int = 0
    var thirdSelectedIndex: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dropDownMenu = DropDownMenu(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 45), themeColor: UIColor(red: 33/255, green: 87/255, blue: 167/255, alpha: 1.0), homeTableView: tableView, menuListData: ["1"])
        dropDownMenu.dataSource = self
        dropDownMenu.delegate = self
        return dropDownMenu
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 45
        } else {
            return 0
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else if section == 1 {
            return 20
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellId")
        cell.textLabel?.text = "测试测试测试测试"
        return cell
    }
}

extension ViewController: DropDownMenuDataSource {
    
    func numberOfColumnsInMenu(menu: DropDownMenu) -> Int {
        return 3
    }
    
    func menu(menu: DropDownMenu, titleForColumn colmu: Int) -> String {
        return titleArr[colmu]
    }
    
    func menu(menu: DropDownMenu, titleForRowAtIndexPath indexPath: DMIndexPath) -> String {
        if indexPath.colum == 0 {
            return data1[indexPath.row]
        } else if indexPath.colum == 1 {
            return data2[indexPath.row]
        } else if indexPath.colum == 2 {
            return data3[indexPath.row]
        }
        else {
            return ""
        }
    }
    
    
    func currentTableViewSelectedRow(column: Int) -> Int {
        if column == 0 {
            return firstSelectedIndex
        } else if column == 1 {
            return secondSelectedIndex
        } else if column == 2 {
            return thirdSelectedIndex
        } else {
            return 0
        }
    }
    
    func numberOfRowsInColumn(menu: DropDownMenu, column: Int, tableViewRow: Int) -> Int {
        if column == 0 {
            return data1.count
        } else if column == 1 {
            return data2.count
        } else if column == 2 {
            return data3.count
        } else {
            return 0
        }

    }
}

extension ViewController: DropDownMenuDelegate {
    func menu(menu: DropDownMenu, didSelectRowAtIndexPath indexPath: DMIndexPath) {
        if indexPath.colum == 0 {
            firstSelectedIndex = indexPath.row
        } else if indexPath.colum == 1 {
            secondSelectedIndex = indexPath.row
        } else if indexPath.colum == 2 {
            thirdSelectedIndex = indexPath.row
        }
    }
}
