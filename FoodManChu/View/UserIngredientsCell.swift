//
//  UserIngredientsCell.swift
//  FoodManChu
//
//  Created by Desiree on 12/4/20.
//

import UIKit

class UserIngredientsCell: UITableViewCell {
    @IBOutlet weak var ingredientLabel: UILabel!
    
    @IBAction func trashPressed(_ sender: UIButton) {
        
    }
    
    func configureCell(ingredient: Ingredient) {
        ingredientLabel.text = ingredient.ingredientName
    }
    
}
