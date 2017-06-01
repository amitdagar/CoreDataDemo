//
//  DetailViewController.swift
//  CoreDataDemo
//
//  Created by Abhishek Gupta on 28/04/17.
//  Copyright © 2017 Abhishek Gupta. All rights reserved.
//

import UIKit
import CoreData
class DetailViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate  {
    
    @IBOutlet weak var tbleView: UITableView!
    var assignMentList:[Assignmentlist] = []
  
    
    lazy var fetchedResultsControllers: NSFetchedResultsController<Assignmentlist> = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Assignmentlist")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        // 1
       
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController as! NSFetchedResultsController<Assignmentlist>
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            try self.fetchedResultsControllers.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
            
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- TABLE VIEW DELEGATE FUNCTION
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customeTableViewCell
        // Fetch Record
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsControllers.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = fetchedResultsControllers.object(at: indexPath)
        
        print(record.order_Id ?? "demo\(indexPath.row)")
        
    }
    
    func configureCell(_ cell: customeTableViewCell, atIndexPath indexPath: IndexPath) {
        // Fetch Record
        let record = fetchedResultsControllers.object(at: indexPath)
        var result: Assignmentlist? = nil
         print("Index path main>>  \(indexPath.row)")
        if (fetchedResultsControllers.sections?.count)! > indexPath.section {
            weak var sectionInfo: NSFetchedResultsSectionInfo? = (fetchedResultsControllers.sections?[indexPath.section])
            if (sectionInfo?.numberOfObjects)! > indexPath.row {
                result = fetchedResultsControllers.object(at: indexPath)
                // Update Cell
                
                
                if let name = result?.assignment_Title {
                    cell.lblTitle.text = name
                    cell.lblOrderId.text = result?.order_Id
                }
               
                
            }
        }
        // Update Cell
        
        
    }
    
    // MARK: Fetched Results Controller Delegate Methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tbleView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tbleView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            
            if let indexPath = newIndexPath {
                tbleView.insertRows(at: [indexPath], with: .fade)
                print("INSERTROW")
                //  self.tbleView.reloadRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tbleView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            print("UPDATE ROW")
            if let indexPath = indexPath {
                let cell = tbleView.cellForRow(at: indexPath) as! customeTableViewCell
                configureCell(cell, atIndexPath: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tbleView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                print("inserrt ROW")
                tbleView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
    
}

