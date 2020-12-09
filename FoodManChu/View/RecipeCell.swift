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
    
    func generateDummyCell() {
        let dummyRecipe = Recipe(context: Constants.context)
            
        
        dummyRecipe.recipeName = "Shrimp Scampi"
        dummyRecipe.imageName = "shrimpScampi"
        dummyRecipe.recipeDescription = "A garlic buttery scampi sauce with a hint of white wine & lemon in less than 10 minutes!"

        recipeImageView.image = UIImage(named: dummyRecipe.imageName!)
        recipeDescription.text = dummyRecipe.recipeDescription
        recipeTitle.text = dummyRecipe.recipeName

        Constants.appDelegate.saveContext()
    }
    
    func configureCell(recipe: Recipe) {
        recipeImageView.image = UIImage(named: recipe.imageName ?? "defaultmade" )
        recipeDescription.text = recipe.recipeDescription
        recipeTitle.text = recipe.recipeName
    }

}
