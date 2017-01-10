//
//  ViewController.swift
//  StickerProfiling
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//  Copyright © 2016 Konta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newButton = MAXFadeBlockButton(frame: CGRect(x: 0,y: 0,width: 120,height: 120) )
        newButton.backgroundColor = UIColor.red
        
        weak var wSelf = self
        
        newButton.buttonTouchUpInside { [weak self] in
            //weak var wSelf = self
            self?.dismiss(animated: true, completion: nil)
        }
        
        self.view.addSubview( newButton )
        /*
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(showNewViewController), for: .touchUpInside)
        self.view.addSubview( button )
        */
        let otherButton = UIButton(frame: CGRect(x: 200, y: 0, width: 120, height: 120))
        otherButton.backgroundColor = UIColor.blue
        otherButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        self.view.addSubview( otherButton )
        
    }
    
    func showNewViewController() {
        let viewDidLoad = ViewController()
        self.present(viewDidLoad, animated: true, completion: nil)
    }
    
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print( CFGetRetainCount(self) )
    }
    
    deinit {
        print("deinit the view controller")
    }
}

