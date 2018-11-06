//
//  ViewController.swift
//  ThirthLab
//
//  Created by Arsanukaev on 30/09/2018.
//  Copyright © 2018 Arsanukaev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource {

    @IBOutlet weak var tfPathToFile: NSTextField!
    
    @IBOutlet weak var tfCountOfEmployees: NSTextField!
    
    @IBOutlet weak var table: NSTableView!
    
    @IBOutlet weak var tableView: NSTableView!
    
    var works = Array<Array<String>>.init()
    
    @IBAction func Calculate(_ sender: NSButton)
    {
        AppDelegate.path = tfPathToFile.stringValue
        AppDelegate.setDictionary()
        
        works = AppDelegate.setDestribution(countOfEmployee: countOfEmployees())
        table.dataSource = self
        //table.delegate = self
        
        table.reloadData()
    }
    
    /**
     Попытается считать число работников с текстового поля.
     */
    func countOfEmployees() -> Int
    {
        if let count = Int(tfCountOfEmployees.stringValue) {
            return count
        }
        else {
            AppDelegate.runAlert(title: "Ошибка", message: "Не удалось распознать число рабочих.\nПопробуйте стереть число и ввести его заного не допуская никаких дополнительных сиволов.")
            
            return 0
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return countOfEmployees()
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
        //Если текущий столбец - это столбец работников
        if tableColumn?.identifier.rawValue == "EmployeeID" {
            return row + 1
        }
        
        //Если текущий столбец - это столбец работ
        else if tableColumn?.identifier.rawValue == "WorkID" {
            return GetRowForEmployee(index: row)
        }
        
        return nil
    }
    
    /**
     Составляет строку работ для работника.
     */
    func GetRowForEmployee(index: Int) -> String
    {
        if index >= works.count {
            return ""
        }
        
        var row = ""
        for i in works[index] {
            row += i + "\t"
        }
        
        return row
    }
}

