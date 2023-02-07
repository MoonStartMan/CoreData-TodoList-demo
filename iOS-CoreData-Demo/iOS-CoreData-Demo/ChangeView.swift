//
//  ChangeView.swift
//  iOS-CoreData-Demo
//
//  Created by 王潇 on 2023/2/6.
//

import UIKit
import SnapKit

enum ChangeViewType {
    case create
    case edit
}

class ChangeView: UIView, UITextViewDelegate {
    
    private var outCoverView: UIView = UIView()
    
    private var contentView: UIView = UIView()
    
    private var titleLabel: UILabel = UILabel()
    
    private var textView: UITextView = UITextView()
    
    private var tipsLabel: UILabel = UILabel()
    
    private var segements: UISegmentedControl!
    
    private var sendBtn: UIButton = UIButton()
    
    var model: TodoList? {
        didSet {
            if let model = model {
                textView.text = model.content
                switch model.level {
                case 1:
                    segements.selectedSegmentIndex = 2
                case 2:
                    segements.selectedSegmentIndex = 1
                case 3:
                    segements.selectedSegmentIndex = 0
                default:
                    segements.selectedSegmentIndex = 0
                }
                todoListString = model.content
                todolistLevel = model.level
            }
        }
    }
    
    private var todoListString: String?
    private var todolistLevel: Int32 = 1
    
    static var changeView: ChangeView!
    
    var storeDataBack: ((_ content: String, _ level: Int32) -> Void)?
    
    convenience init(type: ChangeViewType) {
        self.init(frame: .zero, type: type)
        setupView(type: type)
    }
    
    init(frame: CGRect, type: ChangeViewType) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(type: ChangeViewType) {
        outCoverView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        addSubview(outCoverView)
        outCoverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(corverClick))
        outCoverView.addGestureRecognizer(tap)
        
        outCoverView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.height.equalTo(420)
        }
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
        }
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        if type == .create {
            titleLabel.text = "新增TodoList"
        } else {
            titleLabel.text = "编辑TodoList"
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(200)
        }
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.cornerRadius = 12
        textView.layer.masksToBounds = true
        textView.font = .systemFont(ofSize: 14, weight: .bold)
        textView.text = ""
        textView.delegate = self
        textView.returnKeyType = .done
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        paragraphStyle.firstLineHeadIndent = 10.0
        paragraphStyle.alignment = .left
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        textView.typingAttributes = attributes
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = .white
        textView.textColor = .black
        
        contentView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        tipsLabel.text = "重要情况选择"
        tipsLabel.textColor = .black
        tipsLabel.font = .systemFont(ofSize: 12, weight: .bold)
        tipsLabel.textAlignment = .left
        
        segements = UISegmentedControl(items: ["重要", "普通", "不重要"])
        segements.selectedSegmentIndex = 0
        contentView.addSubview(segements)
        segements.snp.makeConstraints { make in
            make.top.equalTo(tipsLabel.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        segements.backgroundColor = .systemGray6
        segements.addTarget(self, action: #selector(segementDidchange(sender: )), for: .valueChanged)
        segements.selectedSegmentIndex = 0
        
        contentView.addSubview(sendBtn)
        sendBtn.snp.makeConstraints { make in
            make.top.equalTo(segements.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }
        sendBtn.backgroundColor = .systemBlue
        sendBtn.layer.cornerRadius = 20
        sendBtn.layer.masksToBounds = true
        sendBtn.setTitle("确定", for: .normal)
        sendBtn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        sendBtn.addTarget(self, action: #selector(sendData), for: .touchDown)
    }
    
    /// 解决设置键盘返回按钮为done后,仍然是换行功能的BUG.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        todoListString = textView.text
    }
    
    @objc func segementDidchange(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            todolistLevel = 3
        } else if sender.selectedSegmentIndex == 1 {
            todolistLevel = 2
        } else {
            todolistLevel = 1
        }
    }
    
    @objc func sendData() {
        if let todoListString = todoListString {
            storeDataBack?(todoListString, todolistLevel)
        } else {
            print("输入不得为空")
        }
    }
    
    @objc func corverClick() {
        self.removeFromSuperview()
    }
    
    func clearData() {
        textView.text = nil
        segements.selectedSegmentIndex = 0
        todoListString = nil
        todolistLevel = 0
    }
    
    static func showView(type: ChangeViewType) {
        changeView = ChangeView(type: type)
        if let window = UIApplication.shared.connectedScenes
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows.first {
            window.addSubview(changeView)
            changeView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    static func dismissView() {
        changeView.removeFromSuperview()
    }
}
