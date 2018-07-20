//
//  CoreDataHelper.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/29 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {

    @available(iOS 10.0, *)
    func fetchFromCoreDate() -> [Search]?{
        var useDatas = [NSManagedObject]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fechtRequest  = NSFetchRequest<NSManagedObject>(entityName: "Searches")

        do {
            useDatas = try managedContext.fetch(fechtRequest)
            var searchItems = [Search]()
            if useDatas.count > 0 {
                for item in useDatas {
                    let searchItem = Search()
                    searchItem.title = item.value(forKey: "title") as! String
                    searchItems.append(searchItem)
                }
                return searchItems
            }
            else {
                return nil
            }
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }


    }

    @available(iOS 10.0, *)
    func saveToCoreData(info : Search) -> Bool{
        var useDatas = [NSManagedObject]()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName:"Searches",
                                       in: managedContext)!

        let search = NSManagedObject(entity: entity,
                                     insertInto: managedContext)


        search.setValue(info.title , forKeyPath: "title")

        do {
            try managedContext.save()
            useDatas.append(search)
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }

    }

    @available(iOS 10.0, *)
    func deleteSingleFromCoreData(searches : Search){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fechtRequest  = NSFetchRequest<NSManagedObject>(entityName: "Searches")
        let predicate = NSPredicate(format: "title = %@", searches.title)

        fechtRequest.predicate = predicate
        do{
            let result = try managedContext.fetch(fechtRequest)

            if result.count > 0{
                for object in result {
                    print(object)
                    managedContext.delete(object )
                }
            }
        }catch{
            print("item did not delete")
        }

    }

    @available(iOS 10.0, *)
    func deleteAllFromCoreData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fechtRequest  = NSFetchRequest<NSManagedObject>(entityName: "Searches")

        do {
            let nationalCode = try managedContext.fetch(fechtRequest)
            for managedObject in nationalCode
            {
                let managedObjectData:NSManagedObject = managedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in IsLoggedIn error : \(error) \(error.userInfo)")
        }
    }

    @available(iOS 10.0, *)
    func addOrUpdateCoreDate(searchItem : Search) -> Bool{
        let searches =  self.fetchFromCoreDate()
        if searches != nil && (searches?.count)! > 9 {
            self.deleteSingleFromCoreData(searches: searches![0])
        }
        return self.saveToCoreData(info: searchItem)
    }


}
