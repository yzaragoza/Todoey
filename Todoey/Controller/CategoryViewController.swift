//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yaco on 6/20/19.
//  Copyright © 2019 Zaldes Media. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    // MARK TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
        
    }



    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default)
        {
            (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)

            self.saveCategories()
            
            
        }
        
        alert.addTextField
            {
                (alertTextField) in
                alertTextField.placeholder = "Create new category"
                textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    
    // MARK TableView Manipulation Methods
    func saveCategories(){
        
        //let encoder = PropertyListEncoder()
        do {
            try self.context.save()
            //let data = try encoder.encode(itemArray)
            //try data.write(to: dataFilePath!)
        }catch{
            //print("Error encoding item array, \(error)")
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching categories from context, \(error)")
        }
        tableView.reloadData()
    }
    
}
