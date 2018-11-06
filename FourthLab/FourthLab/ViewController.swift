//
//  ViewController.swift
//  FourthLab
//
//  Created by Arsanukaev on 11/10/2018.
//  Copyright © 2018 Arsanukaev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource {
    
    @IBOutlet weak var pathToSource: NSTextField!
    
    @IBOutlet weak var mainTable: NSTableView!
    
    @IBOutlet weak var totalCountLabel: NSTextField!
    
    var works = Array<Array<String>>.init()
    
    @IBAction func distribute(_ sender: NSButton)
    {
        let array = Work.readAsWorks(fromFile: pathToSource.stringValue)
        works = Work.distribute(array: array)
        
        mainTable.dataSource = self
        mainTable.reloadData()
        
        totalCountLabel.stringValue = "Итоговоя продолжительность: \(works[1].count)"
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return works.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
        if tableColumn?.identifier.rawValue == "EmployeeID" {
            return row + 1
        }
        
        else if tableColumn?.identifier.rawValue == "WorksID" {
            return getRow(forEmployee: row)
        }
        
        return nil
    }
    
    func getRow(forEmployee index: Int) -> String
    {
        var row = ""
        
        for i in works[index] {
            row += "\(i) "
        }
        
        return row
    }
}
