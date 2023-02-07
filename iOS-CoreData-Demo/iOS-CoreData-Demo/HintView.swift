//
//  HintView.swift
//  iOS-CoreData-Demo
//
//  Created by 王潇 on 2023/2/6.
//

import UIKit
import SnapKit

class HintView: UIView {
    
    private var titleLabel: UILabel = UILabel()
    
    private var addBtn: UIButton = UIButton()
    
    private var listView: UICollectionView!
    
    private var listLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private var alert: UIAlertController!
    
    var editBack: ((_ id: UUID) -> Void)?
    
    var addBack: (() -> Void)?
    
    var models: [TodoList] = [] {
        didSet {
            listView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
        }
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.text = "ToDo List"
        
        addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.right.equalTo(-16)
            make.width.height.equalTo(24)
        }
        addBtn.setImage(UIImage(named: "icon_add"), for: .normal)
        addBtn.layer.cornerRadius = 12
        addBtn.layer.masksToBounds = true
        addBtn.layer.borderWidth = 1.0
        addBtn.layer.borderColor = UIColor.black.cgColor
        addBtn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        
        listLayout.minimumLineSpacing = 10.0
        listLayout.scrollDirection = .vertical
        listLayout.minimumInteritemSpacing = 0.0
        listLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        listLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        listView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        listView.backgroundColor = .clear
        listView.showsVerticalScrollIndicator = false
        listView.showsHorizontalScrollIndicator = false
        listView.delegate = self
        listView.dataSource = self
        listView.register(HintViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(HintViewCell.self))
    }
    
    @objc func addBtnClick() {
        addBack?()
    }
}

extension HintView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(HintViewCell.self), for: indexPath) as? HintViewCell else {
            fatalError()
        }
        cell.model = models[indexPath.row]
        cell.deleteBack = { [weak self] id in
            guard let self = self else { return }
            
            self.alert = UIAlertController(title: "提示", message: "您确定要删除该条TodoList吗", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default) { action in
                ToDoListDB.deleteList(id: id)
                self.models = ToDoListDB.queryList()
            }
            self.alert.addAction(cancelAction)
            self.alert.addAction(okAction)
            let currentVC = self.getCurrentController()
            currentVC?.present(self.alert, animated: true, completion: nil)
            
        }
        cell.editBack = editBack
        return cell
    }
    
    private func getCurrentController() -> UIViewController? {
        var next = self.next
        repeat {
            if let next = next, next.isKind(of: UIViewController.self) {
                return next as? UIViewController
            }
            next = next?.next
        } while (next != nil)
        return nil
    }
}
