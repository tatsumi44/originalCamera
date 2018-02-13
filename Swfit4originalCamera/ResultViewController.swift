//
//  ResultViewController.swift
//  Swfit4originalCamera
//
//  Created by tatsumi kentaro on 2018/02/13.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var imageData:Data?

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(data:imageData!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
