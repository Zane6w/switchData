//
//  ViewController.swift
//  switchData
//
//  Created by zhi zhou on 2017/1/2.
//  Copyright © 2017年 zhi zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK:- 属性
    fileprivate let tableView = UITableView()
    
    /// section1 头部标签 View
    // 先设置号滚动标识, 防止出错
    fileprivate var indicator = UIView(frame: CGRect(x: 0, y: 39, width: UIScreen.main.bounds.width * 0.5, height: 1))
    fileprivate var leftBtn: UIButton?
    fileprivate var rightBtn: UIButton?
    
    // cell 标识
    fileprivate let topCell = "topCell"
    fileprivate let contentCell = "contentCell"
    
    // 多组数据
    fileprivate var leftData = [String]()
    fileprivate var rightData = [String]()
    
    /// 切换标签标识
    fileprivate var indicatorTag: Int = 0
    
    var userDefault = UserDefaults.standard
    
    // MARK:- 系统函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadLeftData()
        loadRightData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /// 初始化 tableView
    fileprivate func setupTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(TopCell.self, forCellReuseIdentifier: topCell)
    }
    
}

// MARK:- tableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if indicatorTag == 0 {
            return leftData.count
        } else {
            return rightData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: topCell) as! TopCell
            cell.topImageView.image = UIImage(named: "sh")
            
            return cell
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: contentCell)
        
        if indicatorTag == 0 {
            cell.textLabel?.text = "\(leftData[indexPath.row]) - \(indexPath.row)"
            return cell
        } else {
            cell.textLabel?.text = "\(rightData[indexPath.row]) - \(indexPath.row)"
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: topCell) as! TopCell
            return cell.cellHeight
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        return setupHeaderView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if indicatorTag == 0 {
            userDefault.set(offsetY, forKey: "leftLoc")
            userDefault.synchronize()
        } else {
            userDefault.set(offsetY, forKey: "rightLoc")
            userDefault.synchronize()
        }
    }
    
    /// 设置 tableView - headerView
    fileprivate func setupHeaderView() -> UIView {
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 40
        
        let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        headerView.backgroundColor = UIColor.white
        
        // 第一个标签
        let leftBtn = UIButton(type: .system)
        leftBtn.setTitle("Left", for: .normal)
        leftBtn.frame = CGRect(origin: .zero, size: CGSize(width: width * 0.5, height: height))
        leftBtn.addTarget(self, action: #selector(self.clickLeft(sender:)), for: .touchUpInside)
        
        // 第二个标签
        let rightBtn = UIButton(type: .system)
        rightBtn.setTitle("Right", for: .normal)
        rightBtn.frame = CGRect(x: width * 0.5, y: 0, width: width * 0.5, height: height)
        rightBtn.isHighlighted = true
        rightBtn.addTarget(self, action: #selector(self.clickRight(sender:)), for: .touchUpInside)
        
        // 滚动指示器
        indicator.backgroundColor = UIColor.purple
        
        // 防止 reloadData 后 标识出问题
        if indicatorTag == 0 {
            scrolling(indicator: indicator, leftBtn, rightBtn)
        } else {
            scrolling(indicator: indicator, rightBtn, leftBtn)
        }
        
        headerView.addSubview(leftBtn)
        self.leftBtn = leftBtn
        headerView.addSubview(rightBtn)
        self.rightBtn = rightBtn
        headerView.addSubview(indicator)
        
        return headerView
    }
    
    // 标签点击事件
    @objc fileprivate func clickLeft(sender: UIButton) {
        scrolling(indicator: indicator, sender, rightBtn!)
        self.indicatorTag = 0
        self.loadLeftData()
        saveStatus(key: "leftLoc")
    }
    
    @objc fileprivate func clickRight(sender: UIButton) {
        scrolling(indicator: indicator, sender, leftBtn!)
        indicatorTag = 1
        loadRightData()
        saveStatus(key: "rightLoc")
    }
    
}

// MARK:- 界面处理
extension ViewController {
    fileprivate func scrolling(indicator: UIView, _ sender: UIButton, _ otherButton: UIButton) {
        sender.isHighlighted = false
        otherButton.isHighlighted = true
        UIView.animate(withDuration: 0.2) {
            indicator.transform = CGAffineTransform(translationX: sender.frame.origin.x, y: 0)
        }
    }
    
    fileprivate func saveStatus(key: String) {
        let originalOffsetY = tableView.contentOffset.y
        if originalOffsetY >= 136.0 {
            if let offsetY = userDefault.object(forKey: key) as? CGFloat {
                if offsetY >= 136.0 {
                    tableView.contentOffset = CGPoint(x: 0, y: offsetY)
                } else {
                    tableView.contentOffset = CGPoint(x: 0, y: 136.0)
                }
            }
        } else {
            tableView.contentOffset = CGPoint(x: 0, y: originalOffsetY)
        }
    }
}

// MARK:- 模拟数据请求
extension ViewController {
    /// 请求左侧数据
    fileprivate func loadLeftData() {
        for _ in 0...20 {
            leftData.append("Left")
        }
        tableView.reloadData()
    }
    
    /// 请求右侧数据
    fileprivate func loadRightData() {
        for _ in 0...10 {
            rightData.append("Right")
        }
        tableView.reloadData()
    }
    
}

