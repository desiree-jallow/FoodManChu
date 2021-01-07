//
//  ViewController.swift
//  FoodManChu
//
//  Created by Desiree on 12/1/20.
//

import UIKit
import CoreData

class MainVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    var controller: NSFetchedResultsController<Recipe>!
    var selectedRecipe: Recipe?
    var recipe: Recipe?
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRecipes()
//        generateDummyRecipe()
        //generateIngredients()
        //generateCategories()
    }
    
    //generates dummy recipe on app first launch
    override func viewDidAppear(_ animated: Bool) {
        if(!Constants.appDelegate.hasAlreadyLaunched){
            
            //set hasAlreadyLaunched to false
            Constants.appDelegate.setHasAlreadyLaunched()
            //generate dummyRecipe
            generateIngredients()
            generateCategories()
            generateDummyRecipe()
        }
    }
    
    func generateDummyRecipe() {
        let dummyRecipe = Recipe(context: Constants.context)
        let photo = Image(context: Constants.context)
        photo.setImage = UIImage(named: "shrimpScampi")
        dummyRecipe.image = photo
        
        dummyRecipe.recipeName = "Shrimp Scampi"
        
        dummyRecipe.recipeDescription = "A garlic buttery scampi sauce with a hint of white wine & lemon in less than 10 minutes!"
        dummyRecipe.instructions = "1. Heat olive oil and 2 tablespoons of butter in a large pan or skillet. Add garlic and sauté until fragrant (about 30 seconds - 1 minute). Then add the shrimp, season with salt and pepper to taste and sauté for 1-2 minutes on one side (until just beginning to turn pink), then flip.\n \n 2. Pour in wine (or broth), add red pepper flakes (if using). Bring to a simmer for 1-2 minutes or until wine reduces by about half and the shrimp is cooked through (don't over cook your shrimp). \n \n 3. Stir in the remaining butter, lemon juice and parsley and take off heat immediately.\n \n 4. Serve over rice, pasta, garlic bread or steamed vegetables (cauliflower, broccoli, zucchini noodles)."
        
        dummyRecipe.prepTime = 10.0
        
        recipe = dummyRecipe
        fetchCategory()
        fetchIngredients()
        Constants.appDelegate.saveContext()
        
    }
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    func fetchRecipes() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let sort = NSSortDescriptor(key: "recipeName", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Constants.context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        
        Constants.appDelegate.saveContext()
        
    }
    
    func fetchCategory() {
        let categoryFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let predicate = NSPredicate(format: "categoryName MATCHES %@", "Meat")
        categoryFetchRequest.predicate = predicate
        do {
            let categories = try Constants.context.fetch(categoryFetchRequest)
            for category in categories {
                category.addToRecipe(recipe!)
            }
        } catch  {
            print(error.localizedDescription)
        }
        
        
        Constants.appDelegate.saveContext()
        
    }
    
    func fetchIngredients() {
        let ingredientFetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        
        let ingredientsArray = ["shrimp", "olive oil", "butter", "salt", "pepper", "garlic"]
        
        
        let predicate = NSPredicate(format: "ingredientName IN %@", ingredientsArray)
        ingredientFetchRequest.predicate = predicate
        
        
        do {
            let ingredients = try Constants.context.fetch(ingredientFetchRequest)
            for ingredient in ingredients {
                ingredient.isSelected = true
                ingredient.addToRecipe(recipe!)
            }
        } catch  {
            print(error.localizedDescription)
        }
        
        
        Constants.appDelegate.saveContext()
        
    }
    
    func generateIngredients() {
        
        let ingredientsList = ["ground beef", "turkey", "chicken thighs", "shrimp", "tuna fish", "crab", "lamb", "steak", "ground turkey", "chicken breast", "parmesan cheese", "milk", "cream cheese", "cheddar cheese", "yogurt", "buttermilk", "condensed milk", "tilapia", "salmon", "broccoli", "green beans", "tomatoes", "sweet potatoes", "onions", "mushrooms", "lettuce", "shallots", "pumpkin", "jalapeño", "heavy cream","fish stock", "cod", "cat fish","bread crumbs", "salt", "pepper", "soy sauce", "flour","olive oil", "garlic", "butter", "corn","carrot","bell pepper", "spinach","coconut oil","tomato puree","vegetable oil","pasta" ]
        
        for ingredient in ingredientsList {
            let myIngredient = Ingredient(context: Constants.context)
            myIngredient.ingredientName = ingredient
            Constants.appDelegate.saveContext()
        }
    }
    
    func generateCategories() {
        
        let categoriesList = ["Meat", "Vegetarian", "Vegan", "Paleo", "Keto"]
        for category in categoriesList {
            let myCategory = Category(context: Constants.context)
            myCategory.categoryName = category
            
            saveData()
            
        }
    }
    
    func saveData() {
        do {
            try Constants.context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    
    //MARK: - Edit Recipe Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.editRecipe {
            //grab selected recipe and set it to recipeToEdit in RecipeVC
            if let destination = segue.destination as? RecipeVC {
                let indexPath = tableView.indexPathForSelectedRow
                if let objects = controller.fetchedObjects, objects.count > 0 {
                    selectedRecipe = objects[indexPath!.row]
                    destination.recipeToEdit = selectedRecipe
                }
            }
        }
    }
}
//MARK: - Copy Recipe
extension MainVC: RecipeCellDelegate {
    func recipeCell(cell: RecipeCell, didTappedThe button: UIButton?) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let recipeToCopy = controller.object(at: indexPath)
        let newRecipe = Recipe(context: Constants.context)
        newRecipe.categoryType?.categoryName = recipeToCopy.categoryType?.categoryName
        newRecipe.image = recipeToCopy.image
        newRecipe.ingredient = recipeToCopy.ingredient
        newRecipe.instructions = recipeToCopy.instructions
        newRecipe.prepTime = recipeToCopy.prepTime
        newRecipe.recipeDescription = recipeToCopy.recipeDescription
        newRecipe.recipeName = recipeToCopy.recipeName
        Constants.appDelegate.saveContext()
        
        tableView.reloadData()
    }
    
    
}

//MARK: - NSFetchControllerDelegate
extension MainVC {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as? RecipeCell
                cell?.configureCell(recipe: anObject as! Recipe)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        @unknown default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.recipeReuseCell, for: indexPath) as! RecipeCell
        
        let recipe = controller.object(at: indexPath)
        
        cell.configureCell(recipe: recipe)
        cell.recipeDelegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipeToDelete = controller.object(at: indexPath)
            Constants.context.delete(recipeToDelete)
            
            saveData()
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension MainVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let recipeFetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        //check if entered text can be converted to a double
        if let prepTime = Double(searchBar.text!) {
            let timePredicate = NSPredicate(format: "prepTime <= %f", prepTime)
            recipeFetchRequest.predicate = timePredicate
        } else {
            let namePredicate = NSPredicate(format: "recipeName MATCHES[cd] %@", searchBar.text!)
            let categoryPredicate = NSPredicate(format: "categoryType.categoryName ==[cd] %@", searchBar.text!)
            let ingredientPredicate = NSPredicate(format: "ingredient.ingredientName CONTAINS[cd] %@", searchBar.text!)
            let descriptionPredicate = NSPredicate(format: "recipeDescription CONTAINS[cd] %@", searchBar.text!)
            
            recipeFetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [namePredicate, categoryPredicate, ingredientPredicate, descriptionPredicate])
        }
        
        let sort = NSSortDescriptor(key: "recipeName", ascending: true)
        recipeFetchRequest.sortDescriptors = [sort]
        
        let controller = NSFetchedResultsController(fetchRequest: recipeFetchRequest, managedObjectContext: Constants.context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //when search bar is empty reload data 
        if searchBar.text?.count == 0 {
            fetchRecipes()
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}



