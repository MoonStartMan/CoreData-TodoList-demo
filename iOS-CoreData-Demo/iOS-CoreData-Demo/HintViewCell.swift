//
//  HintViewCell.swift
//  iOS-CoreData-Demo
//
//  Created by 王潇 on 2023/2/6.
//

import UIKit
import SnapKit

class HintViewCell: UICollectionViewCell {
    
    private var contentLabel: UILabel = UILabel()
    
    private var editBtn: UIButton = UIButton()
    
    private var deleteBtn: UIButton = UIButton()
    
    var model: TodoList? {
        didSet {
            if let model = model {
                contentLabel.text = model.content
                switch model.level {
                case 1:
                    backgroundColor = .systemGreen
                case 2:
                    backgroundColor = .systemYellow
                case 3:
                    backgroundColor = .systemPink
                default:
                    break
                }
            }
        }
    }
    
    var editBack: ((_ id: UUID) -> Void)?
    
    var deleteBack: ((_ id: UUID) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
        deleteBtn.setImage(UIImage(named: "icon_delete"), for: .normal)
        deleteBtn.layer.cornerRadius = 16
        deleteBtn.layer.masksToBounds = true
        deleteBtn.backgroundColor = .white
        deleteBtn.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
        
        contentView.addSubview(editBtn)
        editBtn.snp.makeConstraints { make in
            make.right.equalTo(deleteBtn.snp.left).offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        editBtn.setImage(UIImage(named: "icon_edit"), for: .normal)
        editBtn.layer.cornerRadius = 16
        editBtn.layer.masksToBounds = true
        editBtn.backgroundColor = .white
        editBtn.addTarget(self, action: #selector(editClick), for: .touchUpInside)
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(editBtn.snp.left).offset(-16)
            make.centerY.equalToSuperview()
        }
        contentLabel.font = .systemFont(ofSize: 14, weight: .black)
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 0
    }
    
    @objc func editClick() {
        if let model = model, let id = model.id {
            print("编辑ID: ---> \(id)")
            editBack?(id)
        }
    }
    
    @objc func deleteClick() {
        if let model = model, let id = model.id {
            print("删除ID: ---> \(id)")
            deleteBack?(id)
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let height = contentLabel.frame.size.height
        var newFrame = attributes.frame
        newFrame.size.width = UIScreen.main.bounds.size.width
        newFrame.size.height = height + 20
        attributes.frame = newFrame
        return attributes
    }
}
