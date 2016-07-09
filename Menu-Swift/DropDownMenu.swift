//
//  DropDownMenu.swift
//  Menu-Swift
//
//  Created by LZQ on 16/5/26.
//  Copyright © 2016年 LZQ. All rights reserved.
//

import UIKit


typealias AnimationComlete = (Void -> Void)
typealias HomeAnimationComplete = ((isReady: Bool) -> Void)

@objc
protocol DropDownMenuDelegate: NSObjectProtocol {
    func menu(menu: DropDownMenu, didSelectRowAtIndexPath indexPath: DMIndexPath)
}

@objc
protocol DropDownMenuDataSource: NSObjectProtocol {
    func menu(menu: DropDownMenu, titleForRowAtIndexPath indexPath: DMIndexPath) -> String
    func menu(menu: DropDownMenu, titleForColumn colmu: Int) -> String
    func numberOfColumnsInMenu(menu: DropDownMenu) -> Int
    func currentTableViewSelectedRow(column: Int) -> Int
    func numberOfRowsInColumn(menu:DropDownMenu, column: Int, tableViewRow: Int) -> Int
}

class DMIndexPath: NSObject {
    var row: Int!
    var colum: Int!
    
    static func indexPathWithCol(col: Int, row: Int) -> DMIndexPath {
        let indexPath = DMIndexPath(col: col, r: row)
        return indexPath
    }
    
    init(col: Int,r: Int) {
        colum = col
        row = r
    }
    
}

class DMTableViewCell: UITableViewCell {
//    var cellTextLabel: UILabel!
//    var cellAccessoryView: UIImageView! {
//        didSet {
//            if cellAccessoryView != nil {
//                cellAccessoryView.removeFromSuperview()
//            }
//            cellAccessoryView.frame = CGRectMake(cellTextLabel.frame.origin.x + cellTextLabel.frame.width + 10, (self.frame.size.height-12)/2, 16, 12)
//            self.addSubview(cellAccessoryView)
//        }
//    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        cellTextLabel = UILabel()
//        cellTextLabel.textAlignment = NSTextAlignment.Center
//        cellTextLabel.font = UIFont.systemFontOfSize(14)
//        self.addSubview(cellTextLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    func setCellText(text: String, align: String) {
//        let textStr = NSString(string: text)
//        let textSize = textStr.textSizeWithFont(UIFont.systemFontOfSize(14), constrainedSize: CGSize(width: CGFloat.max, height: 0), lineBreakMode: NSLineBreakMode.ByWordWrapping)
//        var marginX: CGFloat = 20.0
//        if align != "left" {
//            marginX = (self.frame.size.width - textSize.width) / 2
//        }
//        cellTextLabel.frame = CGRectMake(marginX, 0, textSize.width, self.frame.size.height)
//        if cellAccessoryView != nil {
//            cellAccessoryView.frame = CGRectMake(cellTextLabel.frame.origin.x + cellTextLabel.frame.width + 10, (self.frame.size.height-12)/2, 16, 12)
//        }
//    }
    
}

extension NSString {
    func textSizeWithFont(font: UIFont, constrainedSize: CGSize, lineBreakMode: NSLineBreakMode) -> CGSize {
        var textSize: CGSize
        if CGSizeEqualToSize(constrainedSize, CGSizeZero) {
            let attributes = NSDictionary.init(object: font, forKey: NSFontAttributeName)
            textSize = self.sizeWithAttributes(attributes as? [String : AnyObject])
        } else {
            let attributes = NSDictionary.init(object: font, forKey: NSFontAttributeName)
            let rect = self.boundingRectWithSize(constrainedSize, options: [NSStringDrawingOptions.TruncatesLastVisibleLine,NSStringDrawingOptions.UsesLineFragmentOrigin,NSStringDrawingOptions.UsesFontLeading], attributes: attributes as? [String : AnyObject], context: nil)
            textSize = rect.size
        }
        return textSize
    }
}

class DropDownMenu: UIView {
    
    var numOfMenu: Int = 1
    
    var titleMenuArr = [CATextLayer]()
    var indicatorArr = [CAShapeLayer]()
    
    var homeTableView: UITableView!
    var menuListData = [AnyObject]()
    
    var origin: CGPoint!
    var themeColor: UIColor!
    var currentSelectedMenudIndex: Int!
    var show: Bool!
    var hadSelected: Bool!
    var tableView: UITableView!
    var backGroundView: UIView!
    var topShaow: UIView!
    var bottomShadow: UIView!
    var tableViewSelectRow: Int!
    var indicatorColor = UIColor(red: 175.0/255.0, green: 175.0/255.0, blue: 175.0/255.0, alpha: 1.0)
    var separatorColor = UIColor(red: 203.0/255.0, green: 199.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    var textColor = UIColor(red: 83.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
    
    weak var delegate: DropDownMenuDelegate?
    weak var dataSource: DropDownMenuDataSource? {
        didSet {
            if dataSource!.respondsToSelector(#selector(dataSource!.numberOfColumnsInMenu(_:))) {
                numOfMenu = dataSource!.numberOfColumnsInMenu(self)
            }
            
            let separatorLineOffsetX: CGFloat = self.bounds.width / CGFloat(numOfMenu)
            let textLayerWidth: CGFloat = self.bounds.width / CGFloat(numOfMenu * 2)
            configMenuViewLayer()
            for i in 0..<numOfMenu {
                // title
                let titlePosition = CGPoint(x: CGFloat(i * 2 + 1) * textLayerWidth, y: self.bounds.height / 2)
                let title = dataSource?.menu(self, titleForColumn: i)
                let titleLayer = self.createTextLayerWithNSString(title!, color: textColor, point: titlePosition)
                self.layer.addSublayer(titleLayer)
                titleMenuArr.append(titleLayer)
                // indicator
                let indicator = self.createIndicatorWithColor(indicatorColor, point: CGPoint(x: titlePosition.x + titleLayer.bounds.size.width / 2 + 8, y: self.frame.size.height / 2 + 1))
                self.layer.addSublayer(indicator)
                indicatorArr.append(indicator)
                // separator
                if i != numOfMenu - 1 {
                    let separatorPosition = CGPoint(x: CGFloat(i + 1) * separatorLineOffsetX, y: self.bounds.height / 2)
                    self.layer.addSublayer(self.createSeparatorLineWithColor(separatorColor, point: separatorPosition))
                }
                
            }
            
        }
    }
    
    init(frame: CGRect,themeColor: UIColor, homeTableView: UITableView, menuListData: [AnyObject]) {
        super.init(frame: frame)
        self.themeColor = themeColor
        self.homeTableView = homeTableView
        self.menuListData = menuListData
        origin = self.frame.origin
        currentSelectedMenudIndex = -1
        show = false
        hadSelected = false
        self.backgroundColor = UIColor.whiteColor()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DropDownMenu.menuTapped(_:)))
        self.addGestureRecognizer(tapGesture)
        createTableView()
        createBackgroundTapAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension DropDownMenu {
    
    func configMenuViewLayer() {
        topShaow = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 0.5))
        topShaow.backgroundColor = separatorColor
        self.addSubview(topShaow)
        bottomShadow = UIView(frame: CGRect(x: 0, y: self.bounds.height - 0.5, width: UIScreen.mainScreen().bounds.width, height: 0.5))
        bottomShadow.backgroundColor = separatorColor
        self.addSubview(bottomShadow)
    }
    
    func createTableView() {
        tableView = UITableView(frame: CGRect(x: origin.x, y: origin.y + self.bounds.height, width: 0, height: 0), style: UITableViewStyle.Grouped)
        tableView.rowHeight = 38
        tableView.separatorColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        tableView.delegate = self
        tableView.dataSource = self
        self.autoresizesSubviews = false
        tableView.autoresizesSubviews = false
    }
    
    func createBackgroundTapAction() {
        backGroundView = UIView()
        backGroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        backGroundView.opaque = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DropDownMenu.backgroundTapped(_:)))
        backGroundView.addGestureRecognizer(tapGesture)
    }
    
    func menuTapped(tap: UITapGestureRecognizer) {
        let touchPoint = tap.locationInView(self)
        let tapIndex = Int(touchPoint.x / (self.bounds.width / CGFloat(numOfMenu)))
        for i in 0..<numOfMenu {
            if i != tapIndex {
                self.animateIndicator(indicatorArr[i], forward: false, complete: { (bool) in
                    self.animateTitle(self.titleMenuArr[i], show: false, complete: { (bool) in
                        
                    })
                })
                
            }
        }
        if tapIndex == currentSelectedMenudIndex && show {
            self.animateIndicator(indicatorArr[currentSelectedMenudIndex], background: backGroundView, tableView: tableView, title: titleMenuArr[currentSelectedMenudIndex], forward: false, complete: { (bool) in
                self.currentSelectedMenudIndex = tapIndex
                self.show = false
            })
        } else {
            hadSelected = false
            currentSelectedMenudIndex = tapIndex
            if dataSource!.respondsToSelector(#selector(dataSource!.currentTableViewSelectedRow(_:))) {
                tableViewSelectRow = dataSource?.currentTableViewSelectedRow(currentSelectedMenudIndex)
            }
            tableView.reloadData()
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: self.frame.origin.y + self.frame.size.height, width: self.frame.size.width, height: 0)
            self.animationHomeTableView(homeTableView, indicator: indicatorArr[currentSelectedMenudIndex], background: backGroundView, tableView: tableView, title: titleMenuArr[currentSelectedMenudIndex], forward: true, complete: { (bool) in
                self.show = true
            })
        }
        
        homeTableView.scrollEnabled = !show
    }
    
    func backgroundTapped(tap: UITapGestureRecognizer) {
        
        self.animateIndicator(indicatorArr[currentSelectedMenudIndex], background: backGroundView, tableView: tableView, title: titleMenuArr[currentSelectedMenudIndex], forward: false) { (bool) in
            self.show = false
        }
        homeTableView.scrollEnabled = !show
    }
    
}

extension DropDownMenu {
    
    func createTextLayerWithNSString(string: String, color: UIColor, point: CGPoint) -> CATextLayer {
        let size = self.calculateTitleSizeWithString(string)
        let sizeWidth = (size.width < (self.bounds.width / CGFloat(numOfMenu)) - 25) ? size.width : self.bounds.width / CGFloat(numOfMenu) - 25
        let layer = CATextLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: sizeWidth, height: size.height)
        layer.fontSize = 14.0
        layer.string = string
        layer.alignmentMode = kCAAlignmentCenter
        layer.foregroundColor = color.CGColor
        layer.contentsScale = UIScreen.mainScreen().scale
        layer.position = point
        return layer
    }
    
    func calculateTitleSizeWithString(string: String) -> CGSize {
        let transferStr = NSString(string: string)
        let fontSize: CGFloat = 14.0
        let dic = [NSFontAttributeName:UIFont.systemFontOfSize(fontSize)]
        return transferStr.boundingRectWithSize(CGSize(width: 280, height: 0), options: [NSStringDrawingOptions.TruncatesLastVisibleLine,NSStringDrawingOptions.UsesLineFragmentOrigin] , attributes: dic, context: nil).size
    }
    
    func createIndicatorWithColor(color: UIColor, point: CGPoint) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: 8, y: 0))
        path.addLineToPoint(CGPoint(x: 4, y: 5))
        path.closePath()
        
        layer.path = path.CGPath
        layer.lineWidth = 1.0
        layer.fillColor = color.CGColor
        
        let bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, CGLineCap.Butt, CGLineJoin.Miter, layer.miterLimit)
        layer.bounds = CGPathGetPathBoundingBox(bound)
        layer.position = point
        return layer
    }
    
    func createSeparatorLineWithColor(color: UIColor, point: CGPoint) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 160, y: 0))
        path.addLineToPoint(CGPoint(x: 160, y: self.bounds.height - 20))
        
        layer.path = path.CGPath
        layer.lineWidth = 1.0 / UIScreen.mainScreen().scale
        layer.strokeColor = color.CGColor
        
        let bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, CGLineCap.Butt, CGLineJoin.Miter, layer.miterLimit)
        layer.bounds = CGPathGetPathBoundingBox(bound)
        layer.position = point
        return layer
    }
}

// MARK: - DropDownMenu Animation Method
extension DropDownMenu {
    
    func animationHomeTableView(tableView: UITableView, forward: Bool, complete: AnimationComlete) {
        let rect = tableView.rectForSection(1)
        if tableView.contentOffset.y <= rect.origin.y {
            UIView.animateWithDuration(0.3, animations: {
                tableView.contentOffset.y = rect.origin.y
                self.backGroundView.frame = CGRect(x: 0, y: rect.origin.y + 45, width: self.bounds.width, height: UIScreen.mainScreen().bounds.height)
                }, completion: { (bool) in
                    complete()
            })
        } else {
            self.backGroundView.frame = CGRect(x: 0, y: tableView.contentOffset.y + 45, width: self.bounds.width, height: UIScreen.mainScreen().bounds.height)
            complete()
        }
    }
    
    func animateIndicator(indicator: CAShapeLayer, forward: Bool, complete: AnimationComlete) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.25)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(controlPoints: 0.4, 0.0, 0.2, 1.0))
        let anim = CAKeyframeAnimation(keyPath: "transform.rotation")
        anim.values = forward ? [0, M_PI] : [M_PI, 0]
        
        
        if !anim.removedOnCompletion {
            indicator.addAnimation(anim, forKey: anim.keyPath)
        } else {
            indicator.addAnimation(anim, forKey: anim.keyPath)
            indicator.setValue(anim.values!.last, forKeyPath: anim.keyPath!)
            indicator.fillColor = forward ? themeColor.CGColor : indicatorColor.CGColor
        }
        
        CATransaction.commit()
        complete()
    }
    
    func animateBackGroundView(view: UIView, show: Bool, complete: AnimationComlete) {
        if show {
            self.superview?.addSubview(view)
            view.superview?.addSubview(self)
            
            UIView.animateWithDuration(0.2, animations: { 
                view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            })
        } else {
            UIView.animateWithDuration(0.2, animations: { 
                view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
                }, completion: { (finished) in
                    view.removeFromSuperview()
            })
        }
        complete()
    }
    
    func animateTableView(tableView: UITableView, show: Bool, complete: AnimationComlete) {
        if show {
            var tableViewHeight: CGFloat = 0.0
            tableView.frame = CGRect(x: origin.x, y: homeTableView.contentOffset.y + 45, width: self.bounds.width, height: 0)
            self.superview?.addSubview(tableView)
            tableViewHeight = tableView.numberOfRowsInSection(0) > 5 ? (5 * tableView.rowHeight) : (CGFloat(tableView.numberOfRowsInSection(0)) * tableView.rowHeight)
            UIView.animateWithDuration(0.2, animations: { 
                tableView.frame = CGRect(x: self.origin.x, y: self.homeTableView.contentOffset.y + 45, width: self.bounds.width, height: tableViewHeight)
            })
        } else {
            UIView.animateWithDuration(0.2, animations: { 
                tableView.frame = CGRect(x: self.origin.x, y: self.homeTableView.contentOffset.y + 45, width: self.bounds.width, height: 0)
                }, completion: { (finish) in
                    tableView.removeFromSuperview()
            })
        }
        complete()
    }
    
    func animateTitle(title: CATextLayer, show: Bool, complete: AnimationComlete) {
        let size = self.calculateTitleSizeWithString(title.string as! String)
        let sizeWidth = (size.width < (self.bounds.width / CGFloat(numOfMenu) - 25)) ? size.width : self.bounds.width / CGFloat(numOfMenu) - 25
        title.bounds = CGRect(x: 0, y: 0, width: sizeWidth, height: size.height)
        title.foregroundColor = show ? themeColor.CGColor : textColor.CGColor
        complete()
        
    }
    
    func animationHomeTableView(homeTableView: UITableView,indicator: CAShapeLayer, background: UIView, tableView: UITableView, title: CATextLayer, forward: Bool, complete: AnimationComlete) {
        self.animationHomeTableView(homeTableView, forward: forward) { (bool) in
            self.animateIndicator(indicator, forward: forward) { (bool) in
                self.animateTitle(title, show: forward, complete: { (bool) in
                    self.animateBackGroundView(background, show: forward, complete: { (bool) in
                        self.animateTableView(tableView, show: forward, complete: { (bool) in
                            
                        })
                    })
                })
            }
        }
        complete()
    }
    
    func animateIndicator(indicator: CAShapeLayer, background: UIView, tableView: UITableView, title: CATextLayer, forward: Bool, complete: AnimationComlete) {
            self.animateIndicator(indicator, forward: forward) { (bool) in
                self.animateTitle(title, show: forward, complete: { (bool) in
                    self.animateBackGroundView(background, show: forward, complete: { (bool) in
                        self.animateTableView(tableView, show: forward, complete: { (bool) in
                            
                        })
                    })
                })
            }
        complete()
    }
}

extension DropDownMenu: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 38
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = delegate where delegate!.respondsToSelector(#selector(delegate?.menu(_:didSelectRowAtIndexPath:))) {
            confiMenuWithSelectRow(indexPath.row)
            delegate!.menu(self, didSelectRowAtIndexPath: DMIndexPath(col: currentSelectedMenudIndex, r: indexPath.row))
        }
        homeTableView.scrollEnabled = true
    }
    
    func confiMenuWithSelectRow(row: Int) {
        let titleTextLayer = titleMenuArr[currentSelectedMenudIndex]
        let indicator = indicatorArr[currentSelectedMenudIndex]
        titleTextLayer.string = dataSource!.menu(self, titleForRowAtIndexPath: DMIndexPath(col: self.currentSelectedMenudIndex, r: row))
        animateIndicator(indicatorArr[currentSelectedMenudIndex], background: backGroundView, tableView: tableView, title: titleMenuArr[currentSelectedMenudIndex], forward: false) { (bool) in
            self.show = false
        }
        indicator.position = CGPoint(x: titleTextLayer.position.x + titleTextLayer.frame.size.width / 2 + 5, y: indicator.position.y)
    }
}

private let identifier = "DropDownMenuCell"
extension DropDownMenu: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource!.respondsToSelector(#selector(dataSource!.numberOfRowsInColumn(_:column:tableViewRow:))) {
            return dataSource!.numberOfRowsInColumn(self, column: currentSelectedMenudIndex, tableViewRow: tableViewSelectRow)
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = DMTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        let titleLbl = UILabel()
        let logoImg = UIImageView(frame: CGRect(x: 16, y: 12.5, width: 16, height: 16))
        titleLbl.textColor = UIColor.blackColor()
        titleLbl.tag = 1
        titleLbl.font = UIFont.systemFontOfSize(14)
        cell.addSubview(titleLbl)
        cell.addSubview(logoImg)
        var textSize = CGSize()
        if dataSource!.respondsToSelector(#selector(dataSource!.menu(_:titleForRowAtIndexPath:))) {
            let dmIndexPath = DMIndexPath.indexPathWithCol(self.currentSelectedMenudIndex, row: indexPath.row)
            titleLbl.text = dataSource?.menu(self, titleForRowAtIndexPath: dmIndexPath)
            
            let newStr = NSString(string: titleLbl.text!)
            textSize = newStr.textSizeWithFont(UIFont.systemFontOfSize(14), constrainedSize: CGSizeMake(CGFloat.max, 14), lineBreakMode: NSLineBreakMode.ByWordWrapping)
        }
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        cell.separatorInset = UIEdgeInsetsZero
        
        let marginX: CGFloat = 20.0

        titleLbl.frame = CGRectMake(marginX, 0, textSize.width, cell.frame.size.height - 3)
        
        if !hadSelected && tableViewSelectRow == indexPath.row {
            titleLbl.textColor = themeColor
            let accessoryImg = UIImageView(image: UIImage(named: "ico_make"))
            accessoryImg.frame = CGRectMake(self.bounds.size.width - 35, cell.frame.size.height / 2 - 8, 16, 12)
            cell.contentView.addSubview(accessoryImg)
        }
        
        return cell
    }
}
