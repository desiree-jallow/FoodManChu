//
//  RecipeCell.swift
//  FoodManChu
//
//  Created by Desiree on 12/2/20.
//

import UIKit
import CoreData

protocol RecipeCellDelegate: UIViewController {
    func recipeCell(cell: RecipeCell, didTappedThe button: UIButton?)
}
class RecipeCell: UITableViewCell {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    
    weak var recipeDelegate: RecipeCellDelegate?
    
    @IBAction func copyPressed(_ sender: UIButton) {
       recipeDelegate?.recipeCell(cell: self, didTappedThe: sender)
    }
    
    func configureCell(recipe: Recipe) {
        recipeImageView.image = recipe.image?.setImage as? UIImage ?? UIImage(named: "default")
        recipeDescription.text = recipe.recipeDescription
        recipeTitle.text = recipe.recipeName
    }

}
