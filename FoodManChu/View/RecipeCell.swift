//
//  RecipeCell.swift
//  FoodManChu
//
//  Created by Desiree on 12/2/20.
//

import UIKit
import CoreData

class RecipeCell: UITableViewCell {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    
   
    
    func configureCell(recipe: Recipe) {
//        recipeImageView.image = UIImage(named: recipe.imageName ?? "defaultmade" )
        recipeImageView.image = recipe.image?.setImage as? UIImage ?? UIImage(named: "default")
        recipeDescription.text = recipe.recipeDescription
        recipeTitle.text = recipe.recipeName
    }

}
