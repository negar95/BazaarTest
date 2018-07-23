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
    func fetchFromCoreData() -> [Search]?{
        var data = [NSManagedObject]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fechtRequest  = NSFetchRequest<NSManagedObject>(entityName: "Searches")

        do {
            data = try managedContext.fetch(fechtRequest)
            var searchItems = [Search]()
            if data.count > 0 {
                for item in data {
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
    func saveToCoreData(search : Search) -> Bool{
        var data = [NSManagedObject]()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName:"Searches",
                                       in: managedContext)!

        let searchObj = NSManagedObject(entity: entity,
                                     insertInto: managedContext)


        searchObj.setValue(search.title , forKeyPath: "title")

        do {
            try managedContext.save()
            data.append(searchObj)
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }

    }

    @available(iOS 10.0, *)
    func deleteSingleFromCoreData(search : Search){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fechtRequest  = NSFetchRequest<NSManagedObject>(entityName: "Searches")
        let predicate = NSPredicate(format: "title = %@", search.title)

        fechtRequest.predicate = predicate
        do{
            let result = try managedContext.fetch(fechtRequest)

            if result.count > 0{
                for object in result {
                    managedContext.delete(object )
                }
            }
        }catch{
            print("couldn't delete the item!")
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
            let data = try managedContext.fetch(fechtRequest)
            for obj in data
            {
                let managedObjectData:NSManagedObject = obj
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data error : \(error) \(error.userInfo)")
        }
    }


    @available(iOS 10.0, *)
    func pushToCoreDataStack(search : Search) -> Bool{
        let searches =  self.fetchFromCoreData()
        if searches != nil{
            for entity in searches!{
                if search.title == entity.title{
                    return true
                }
            }
            if (searches?.count)! > 9 {
                self.deleteSingleFromCoreData(search: searches![0])
            }
        }
        return self.saveToCoreData(search: search)
    }


}
