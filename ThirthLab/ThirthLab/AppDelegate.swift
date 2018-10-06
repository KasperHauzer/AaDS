//
//  AppDelegate.swift
//  ThirthLab
//
//  Created by Arsanukaev on 30/09/2018.
//  Copyright © 2018 Arsanukaev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    static var path = "input.txt"
    static var works = Dictionary<String, Work>.init()
    
    class func main()
    {
        setDictionary()
    }
    
    /**
     Показывает сообщение с указанным заголовком и текстов.
     - Parameter title: заголовок диалогового окна.
     - Parameter message: текст, которой отобразится в диалоговом окне.
     */
    class func runAlert(title: String, message: String)
    {
        let alert = NSAlert.init()
        alert.informativeText = message
        alert.messageText = title
        alert.addButton(withTitle: "Понятно")
        alert.runModal()
    }
    
    /**
     Попытается считать содержимое файла.
     Если не удастся сделать это, то оповестит в
     диалоговом окне.
     */
    private class func readAllText(path: String) -> String?
    {
        do {
            return try String.init(contentsOfFile: path)
        } catch {
            runAlert(title: "Ошибка", message: "Не удалось прочитать содержимое файла.")
            return nil
        }
    }
    
    /**
     Считывает все строки из файла.
     */
    private class func readAllLines(path: String) -> Array<String>
    {
        let text = readAllText(path: path) ?? ""
        var strings = Array<String>.init()
        
        for x in text.split(separator: "\n") {
            strings.append(String(x))
        }
        
        return strings
    }
    
    /**
     Составляет словарь работ.
     */
    class func setDictionary()
    {
        works.removeAll()
        
        for i in readAllLines(path: path) {
            
            var strs = i.split(separator: " ")
            
            let a = Work.init(title: String(strs[0]))
            var b = Work.init(title: String(strs[1]))
            
            //Если зависимая работа не занесена в словарь.
            if !works.contains(where: { x in
                x.value.title == b.title
            }) {
                b.listOfSuperWorks.append(a.title)
                works.updateValue(b, forKey: b.title)
            } else {
                works[b.title]!.listOfSuperWorks.append(a.title)
                b = works[b.title]!
            }
            
            //Если супер-работа не занесена в словарь.
            if !works.contains(where: { x in
                x.value.title == a.title
            }) {
                a.hasChild = true
                works.updateValue(a, forKey: a.title)
            }
        }
        
        //Расставляем приоритеты
        var priority = 1
        var currentWork = works.first(where: { x in
            return x.value.hasChild == false
        })!.value
        var tmpList = Array<Work>.init()
        tmpList.append(currentWork)
        
        repeat {
            currentWork.priority = priority
            priority += 1
            
            for i in currentWork.listOfSuperWorks {
                tmpList.append(works[i]!)
            }
            
            tmpList.removeFirst()
            currentWork = tmpList.first ?? Work.init(title: "-")
        } while tmpList.count != 0
    }
    
    /**
     Создает массив с распределениями работ.
     */
    class func setDestribution(countOfEmployee: Int) -> Array<Array<String>>
    {
        var nsWorks = works
        var distrib = Array<Array<String>>.init()
        var countOfWorks = works.count
        var indexOfEmployee = 0
        var tmpList = Array<String>.init()
        
        //Создаем в массиве массивов столько массивов,
        //сколько доступно рабочих.
        for _ in 0..<countOfEmployee {
            distrib.append(Array<String>.init())
        }
        
        while countOfWorks != 0 {
            var currentWork = nsWorks.max(by: { left, right in
                return left.value.priority < right.value.priority
            })!.value
            
            //Проверяем, выполнены ли все супер-работы.
            var ok = true
            for i in currentWork.listOfSuperWorks {
                if !works[i]!.isComplited { ok = false; break }
            }
            
            //Работа готова к выполнению.
            if ok {
                distrib[indexOfEmployee].append(currentWork.title)
                indexOfEmployee += 1
                countOfWorks -= 1
            } else {
                ok = true
                for i in nsWorks.values {
                    if i.listOfSuperWorks.count == 0 { currentWork = i; ok = true; break }
                    for j in i.listOfSuperWorks {
                        if !works[j]!.isComplited { ok = false; break}
                    }
                    if ok { currentWork = i; break }
                }
                if ok {
                    distrib[indexOfEmployee].append(currentWork.title)
                    indexOfEmployee += 1
                    countOfWorks -= 1
                } else {
                    currentWork = Work.init(title: "-")
                    distrib[indexOfEmployee].append(currentWork.title)
                    indexOfEmployee += 1
                }
            }
            
            //Помечаем текущую работу как сделанную
            //в основном массивеи удаляем ее
            //из вспомогательного массива
            tmpList.append(currentWork.title)
            if let index = nsWorks.index(forKey: currentWork.title) {
                nsWorks.remove(at: index)
            }
            
            //Переходим к следующему цмклу выполнения работ
            //рабочими, если текущий рабочий был последним
            //из общего числа.
            if indexOfEmployee == countOfEmployee {
                indexOfEmployee = 0
                
                for i in tmpList {
                    works[i]?.isComplited = true
                }
                tmpList.removeAll()
            }
        }
        
        return distrib
    }
}
