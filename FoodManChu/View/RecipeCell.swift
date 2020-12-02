//
//  RecipeCell.swift
//  FoodManChu
//
//  Created by Desiree on 12/2/20.
//

import UIKit

class RecipeCell: UITableViewCell {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    
    func configurCell() {
        let recipe = Recipe(context: Constants.context)
        recipe.recipeName = "Shrimp Scampi"
        recipe.imageName = "shrimpScampi"
        recipe.recipeDescription = "A garlic buttery scampi sauce with a hint of white wine & lemon in less than 10 minutes!"
        
        recipeImageView.image = UIImage(named: recipe.imageName!)
        recipeDescription.text = recipe.recipeDescription
        recipeTitle.text = recipe.recipeName
        
        Constants.appDelegate.saveContext()
    }

}
