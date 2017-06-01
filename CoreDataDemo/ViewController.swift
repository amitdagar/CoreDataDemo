//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Abhishek Gupta on 27/04/17.
//  Copyright © 2017 Abhishek Gupta. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {

    @IBOutlet weak var tbleView: UITableView!
  
    lazy var fetchedhResultController: NSFetchedResultsController<Assignmentlist> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Assignmentlist")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc as! NSFetchedResultsController<Assignmentlist>
    }()
    
       override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
        } catch let error  {
            print("ERROR: \(error)")
        }

         let service = APIService()
        service.getDataWith { (result) in
            switch result {
            case .Success(let data):
                self.clearData()
                self.saveInCoreDataWith(array: data)
                
                
            case .Error(let message):
                DispatchQueue.main.async {
                    print("error  \(message)")
                  //  self.showAlertWith(title: "Error", message: message)
                }
            }
        }

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
        if let sections = fetchedhResultController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
//        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
//            return count
//        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = fetchedhResultController.object(at: indexPath)
        
        print(record.order_Id ?? "demo\(indexPath.row)")

    }
 /*   func save(orderId: String, title:String) {
      
    
        let entity =
            NSEntityDescription.entity(forEntityName: "Assignmentlist",
                                       in: managedObjectContext)!
   
        let predicate = NSPredicate(format: "order_Id == %@", orderId)
        self.fetchedhResultController.fetchRequest.predicate = predicate
        self.fetchedhResultController.fetchRequest.fetchLimit = 1
     
        do{
            let count = try self.managedObjectContext.count(for: self.fetchedhResultController.fetchRequest)
            if(count == 0){
                // no matching object
                print("no matching object")
                 let assignMentObj = Assignmentlist(entity: entity, insertInto: managedObjectContext)
                assignMentObj.order_Id = orderId
                assignMentObj.assignment_Title = title
                // 4
             
                do {
                  try  assignMentObj.managedObjectContext?.save()
                  //  try managedObjectContext.save()
                   // self.tbleView.reloadData()
                    
                    
                    //   assignMentList.append(assignMentObj)
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            else{
                // at least one matching object exists
                   print("at least one matching object exists \(orderId)")
            }
           
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

    }
 */
    
    func configureCell(_ cell: customeTableViewCell, atIndexPath indexPath: IndexPath) {
        // Fetch Record
        //let record = fetchedResultsController.object(at: indexPath)
        print("Index path main>>  \(indexPath.row)")

        var result: Assignmentlist? = nil
        if (fetchedhResultController.sections?.count)! > indexPath.section {
            weak var sectionInfo: NSFetchedResultsSectionInfo? = (fetchedhResultController.sections?[indexPath.section])
            if (sectionInfo?.numberOfObjects)! > indexPath.row {
                result = fetchedhResultController.object(at: indexPath)
                // Update Cell
               
                
                    cell.lblOrderId.text = result?.order_Id
                

            }
        }
     
    
        
    }

    private func clearData() {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Assignmentlist")
            do {
                let objects  = try context.fetch(fetchRequest) as? [Assignmentlist]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    //MARK:- Save dictionory to core data
    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createRecordEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    //MARK:- Set dictionory item to NSObject
    private func createRecordEntityFrom(dictionary: [String: AnyObject]) -> Assignmentlist? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let record = NSEntityDescription.insertNewObject(forEntityName: "Assignmentlist", into: context) as? Assignmentlist {
            record.order_Id = dictionary["Order_Id"] as? String
            record.assignment_Title = dictionary["Assignment_Title"] as? String
            return record
        }
        return nil
    }
   
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tbleView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tbleView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tbleView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tbleView.beginUpdates()
    }
}



