//
//  ViewController.swift
//  FoodManChu
//
//  Created by Desiree on 12/1/20.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    var recipes = [Recipe]()
    var selectedRecipe: Recipe?
    let fetchController = NSFetchedResultsController<Recipe>()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        generateDummyRecipe()
        fetchRecipes()
//        deleteAll()
                // Do any additional setup after loading the view.
    }
    
    func generateDummyRecipe() {
        
        let dummyRecipe = Recipe(context: Constants.context)
            
        dummyRecipe.recipeName = "Shrimp Scampi"
        dummyRecipe.imageName = "shrimpScampi"
        dummyRecipe.recipeDescription = "A garlic buttery scampi sauce with a hint of white wine & lemon in less than 10 minutes!"
        dummyRecipe.instructions = "1. Heat olive oil and 2 tablespoons of butter in a large pan or skillet. Add garlic and sauté until fragrant (about 30 seconds - 1 minute). Then add the shrimp, season with salt and pepper to taste and sauté for 1-2 minutes on one side (until just beginning to turn pink), then flip.\n 2. Pour in wine (or broth), add red pepper flakes (if using). Bring to a simmer for 1-2 minutes or until wine reduces by about half and the shrimp is cooked through (don't over cook your shrimp). \n 3. Stir in the remaining butter, lemon juice and parsley and take off heat immediately.\n 4. Serve over rice, pasta, garlic bread or steamed vegetables (cauliflower, broccoli, zucchini noodles)."
    
        dummyRecipe.prepTime = 30.0
        dummyRecipe.categoryType?.categoryName = "Meat"
        
        Constants.appDelegate.saveContext()
    }

    
    func fetchRecipes() {
        let fetchRequest = NSFetchRequest<Recipe>(entityName: "Recipe")
        
        do {
            recipes = try Constants.context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
            }
        }
    func fetch() {
        do {
            try fetchController.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    func deleteAll() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
           let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

           do {
            try Constants.context.execute(deleteRequest)
            try Constants.context.save()
           } catch {
               print ("There was an error")
           }
    }
    
    
//MARK: - Edit Recipe Segue
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //edit recipe segue
        // Get the new view controller using segue.destination.
    
    if segue.identifier == Constants.editRecipe {
        if let destination = segue.destination as? RecipeVC {
            if let index = tableView.indexPathForSelectedRow {
                fetch()
                selectedRecipe = fetchController.object(at: index)
                destination.descTextField.text = selectedRecipe?.recipeDescription
                destination.categoryTextField.text = selectedRecipe?.categoryType?.categoryName
                destination.instructionsTextField.text = selectedRecipe?.instructions
                destination.prepTextField.text = String(selectedRecipe?.prepTime ?? 0.0)
                destination.recipeImage.image = selectedRecipe?.image?.image as? UIImage
            }
          }
      }
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.recipeReuseCell, for: indexPath) as! RecipeCell
        
        let recipe = recipes[indexPath.row]
      
        cell.configureCell(recipe: recipe)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
        
}


