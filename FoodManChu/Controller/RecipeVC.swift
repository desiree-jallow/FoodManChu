//
//  RecipeVC.swift
//  FoodManChu
//
//  Created by Desiree on 12/2/20.
//

import UIKit
import CoreData

class RecipeVC: UIViewController  {

    @IBOutlet weak var instructionsTextField: UITextView!
    @IBOutlet weak var descTextField: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var prepTextField: UITextField!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var prepSlider: UISlider!
    @IBOutlet weak var categoryTextField: UITextField!
    
    let picker = UIPickerView()
    var imagePicker = UIImagePickerController()
    
    var categories = [Category]()
    var ingredientsArray = [Ingredient]()
    var recipeToEdit: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorder(for: descTextField)
        setBorder(for: instructionsTextField)
        imagePicker.delegate = self
        prepTextField.delegate = self
        categoryTextField.inputView = picker
        picker.delegate = self
//        generateCategories()
//        deleteCategories()
        Constants.context.mergePolicy  = NSMergeByPropertyStoreTrumpMergePolicy
        fetchCategories()
        if recipeToEdit != nil {
            loadFields(with: recipeToEdit!)
        }
        
        // Do any additional setup after loading the view.
    }
    //MARK: - Save Recipe
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        var recipe: Recipe!
        
        if recipeToEdit != nil {
            recipe = recipeToEdit
        } else {
            recipe = Recipe(context: Constants.context)
        }
           
        let selectedCategory = categoryTextField.text
        recipe.categoryType?.categoryName = selectedCategory
            for category in categories {
                if category.categoryName == selectedCategory {
                    category.addToRecipe(recipe)
                }
            }
            
        recipe.instructions = instructionsTextField.text
        recipe.recipeDescription = descTextField.text
        recipe.recipeName = nameTextField.text
        
        let photo = Image(context: Constants.context)
        photo.setImage = recipeImage.image
        recipe.image = photo
        
        if let prepText = prepTextField.text, let doubleText = Double(prepText) {
            recipe.prepTime = doubleText
        }
        for ingredient in ingredientsArray {
//            ingredient.isSelected = true
            ingredient.addToRecipe(recipe)
        }
        saveData()
}
    //make sure the correct ingredients are checked
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if recipeToEdit != nil {
            if segue.identifier == Constants.ingredientsSegue {
                if let destination = segue.destination as? IngredientsVC {
                    destination.recipe = recipeToEdit
                }
            }
        }
    }
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let newValue = Int(sender.value/5) * 5
        sender.setValue(Float(newValue), animated: false)
        prepTextField.text = String(newValue)
    }
    
    
//MARK: - UIImagePicker Delegate
     
    @IBAction func imageButtonPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
}
   
extension RecipeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            recipeImage.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UIPickerView
extension RecipeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].categoryName
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row].categoryName
        self.view.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate
extension RecipeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = prepTextField.text {
            let value = Float(text) ?? 240.0
            prepSlider.setValue(value, animated: true)
            prepTextField.resignFirstResponder()
        }
        return true
    }
}

//MARK: - Helper Functions
extension RecipeVC {
    //MARK: - Set textView border
    func setBorder(for textView: UITextView) {
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    //MARK: - Load Fields when editing Recipe
    func loadFields(with recipe: Recipe) {
        descTextField.text = recipe.recipeDescription
        descTextField.frame.size.width = descTextField.intrinsicContentSize.width
        categoryTextField.text = recipe.categoryType?.categoryName
        instructionsTextField.text = recipe.instructions
        instructionsTextField.frame.size.width = instructionsTextField.intrinsicContentSize.width
        prepTextField.text = String(format: "%.0f", recipe.prepTime )
        recipeImage.image = recipe.image?.setImage as? UIImage
        nameTextField.text = recipe.recipeName
        if let prepText = Float(prepTextField.text ?? "") {
            prepSlider.setValue(prepText, animated: true)
        }
    }
    
//    func generateCategories() {
//
//        let categories = ["Meat", "Vegetarian", "Vegan", "Paleo", "Keto"]
//        for category in categories {
//            let myCategory = Category(context: Constants.context)
//            myCategory.categoryName = category
//            saveData()
//        }
//    }
    
    func fetchCategories() {
        
            let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
            
            do {
                categories = try Constants.context.fetch(fetchRequest)
            } catch  {
                print(error.localizedDescription)
            }
            
        }
    
    func deleteCategories() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
           let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

           do {
            try Constants.context.execute(deleteRequest)
            try Constants.context.save()
           } catch {
               print ("There was an error")
           }
    }
    
    func saveData() {
        do {
            try Constants.context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
}
