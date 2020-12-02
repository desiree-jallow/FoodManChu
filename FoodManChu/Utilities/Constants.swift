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
    static let cellReuseID = "RecipeCell"
    
    static let addRecipe = "AddRecipeSegue"
    
    static let editRecipe = "EditRecipeSegue"
}
