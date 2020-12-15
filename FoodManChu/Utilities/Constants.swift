//
//  Constants.swift
//  FoodManChu
//
//  Created by Desiree on 12/2/20.
//

import Foundation
import UIKit

struct Constants {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
    static let recipeReuseCell = "recipeCell"
    
    static let addRecipe = "addRecipeSegue"
    static let editRecipe = "editRecipeSegue"
    static let ingredientsSegue = "ingredientsSegue"
    static let saveSegue = "saveSegue"
    
    static let ingredientsReuseCell = "ingredientsCell"
    static let userIngredientsCell = "userIngredientsCell"
}
