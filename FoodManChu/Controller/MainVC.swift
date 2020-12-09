//
//  ViewController.swift
//  FoodManChu
//
//  Created by Desiree on 12/1/20.
//

import UIKit

class MainVC: UIViewController {
    var recipes = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//MARK: - Edit Recipe Segue
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //edit recipe segue
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.recipeReuseCell, for: indexPath) as! RecipeCell
        
        cell.generateDummyCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}

