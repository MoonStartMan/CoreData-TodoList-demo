//
//  ViewController.swift
//  iOS-CoreData-Demo
//
//  Created by 王潇 on 2023/2/6.
//

import UIKit

class ViewController: UIViewController {
    
    private var hintView: HintView = HintView()
    
    private var alert: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(hintView)
        hintView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        ToDoListDB.createList(content: "Every woman deserves to shine in this world, inside and out. Don’t let anything or anyone let you doubt how beautiful you are because you are a gem like no other.", level: 1)
//        ToDoListDB.createList(content: "Life sometimes seems too hard and difficult to understand but no matter what obstacles are standing in your way right now you have the power to overcome them. Sometimes your strength lies in stubbornness and determination but even more often it is hidden in your ability to go around obstacles and learn from the previous mistakes. Be strong as a fire that crushes everything in its way and like water that finds a way around any obstacle with gentle determination and a peaceful flow.", level: 2)
//        ToDoListDB.createList(content: "You have unique gifts and talents that no one else in this world has. Sometimes we feel that we need to be someone else in order to fit in, be a better mother or wife, or portray an image that we believe everyone else will love. No matter how hard you try to be someone else you will never be good enough. You willdo the best and be the happiest only if you stop living by someone else’s standards and start using your unique potential to shine like a light in this world.", level: 3)
//        ToDoListDB.createList(content: "We spend a big part of our lives trying to make others like us. The truth is that no one will ever like you if you don’t start loving yourself first. Give your love to others like you do every day already but don’t forget to leave some for yourself. Spend some time reading your favorite book, exercising, giving yourself a manicure or enjoy a relaxing bubble bath. You are worth it!", level: 1)
        
        hintView.models = ToDoListDB.queryList()
        hintView.editBack = { id in
            let model = ToDoListDB.queryListWithId(id: id)
            ChangeView.showView(type: .edit)
            ChangeView.changeView.model = model
            ChangeView.changeView.storeDataBack = { [weak self] (todoListString, todolistLevel) in
                guard let self = self else { return }
                ToDoListDB.updateList(id: id, content: todoListString, level: todolistLevel)
                self.hintView.models = ToDoListDB.queryList()
                ChangeView.dismissView()
            }
        }
        
        hintView.addBack = {
            ChangeView.showView(type: .create)
            ChangeView.changeView.clearData()
            ChangeView.changeView.storeDataBack = { [weak self] (todoListString, todolistLevel) in
                guard let self = self else { return }
                ToDoListDB.createList(content: todoListString, level: todolistLevel)
                self.hintView.models = ToDoListDB.queryList()
                ChangeView.dismissView()
            }
        }
    }
    
}

