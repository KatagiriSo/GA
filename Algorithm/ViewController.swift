//
//  ViewController.swift
//  Algorithm
//
//  Created by 片桐奏羽 on 2015/08/25.
//  Copyright (c) 2015年 SoKatagiri. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //var cellData: NSArray = ["クイックソート","アルゴリズム1","アルゴリズム2", "アルゴリズム3", "アルゴリズム4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.topLayoutGuide
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        var b = BitStringMaker(codeLength: 3, min: 1, max: 5)
        var l = b.encode(4)
        var ga = GA()
        ga.main()
    }


    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return self.cellData.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
//    {
//        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
//        cell.textLabel?.text = self.cellData[indexPath.row] as? String
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }


}

