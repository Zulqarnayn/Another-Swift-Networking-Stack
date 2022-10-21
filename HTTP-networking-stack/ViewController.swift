//
//  ViewController.swift
//  HTTP-networking-stack
//
//  Created by Asif Mujtaba on 5/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    let starwarsApi = StarWarsAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        starwarsApi.requestPeople {
            print($0)
        }
    }


}

