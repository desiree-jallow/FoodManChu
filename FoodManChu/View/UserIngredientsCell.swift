//
//  UserIngredientsCell.swift
//  FoodManChu
//
//  Created by Desiree on 12/4/20.
//

import UIKit
protocol CustomCellDelegate: UITableViewController {
    func customCell(cell: UserIngredientsCell, didTappedThe button: UIButton?)
}
 

class UserIngredientsCell: UITableViewCell {
    @IBOutlet weak var ingredientLabel: UILabel!
    
    weak var cellDelegate:CustomCellDelegate?
    
    //tells delegate when the trash can button is pressed
    @IBAction func trashPressed(_ sender: UIButton) {
        cellDelegate?.customCell(cell: self, didTappedThe: sender)
        
    }
    
    func configureCell(ingredient: Ingredient) {
        ingredientLabel.text = ingredient.ingredientName
    }
    
}
