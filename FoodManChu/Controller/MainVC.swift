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
    
    var manager = CoreDataManager()
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.fetchRecipes()
        controller = manager.recipeController
        controller.delegate = self
        //manager.generateDummyRecipe()
        //manager.generateIngredients()
        //manager.generateCategories()
    }
    
    //generates dummy recipe on app first launch
    override func viewDidAppear(_ animated: Bool) {
        if(!Constants.appDelegate.hasAlreadyLaunched){
            
            //set hasAlreadyLaunched to false
            Constants.appDelegate.setHasAlreadyLaunched()
            manager.generateIngredients()
            manager.generateCategories()
            manager.generateDummyRecipe()
        }
    }
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
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
            
            manager.saveData()
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
            manager.fetchRecipes()
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}



