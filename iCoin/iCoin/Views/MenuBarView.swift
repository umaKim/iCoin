//
//  MenuBarView.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import CombineCocoa
import Combine
import UIKit.UIView

enum MenuTabBarButtonType: Int {
    case myList = 0
    case orderBook = 1
    case opinions = 2
}

//enum MenuBarButtonAction {
//    case didTapMyList
//    case didTapOpinions
//    //    case didTapEditting
//}
//
//final class MenuBarView: UIView {
//    // MARK: - UI Objects
//    private let myListButton: MenuBarButton = MenuBarButton(title: "Coin")
//    private let opinionsButton: MenuBarButton = MenuBarButton(title: "Opinions")
//    private let separator: UIView = {
//        let uv = UIView()
//        uv.backgroundColor = .systemGray
//        uv.layer.opacity = 0.5
//        uv.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        return uv
//    }()
//
//    //MARK: - Combine
//    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
//    private let actionSubject = PassthroughSubject<MenuBarButtonAction, Never>()
//    private var cancellable: Set<AnyCancellable>
//
//    //MARK: - Init
//    override init(frame: CGRect) {
//        self.cancellable = .init()
//        super.init(frame: .zero)
//
//        bind()
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//// MARK: - Bind
//extension MenuBarView {
//    private func bind() {
//        myListButton
//            .tapPublisher
//            .sink {[weak self] _ in
//                self?.actionSubject.send(.didTapMyList)
//            }
//            .store(in: &cancellable)
//
//        opinionsButton
//            .tapPublisher
//            .sink {[weak self] _ in
//                self?.actionSubject.send(.didTapOpinions)
//            }
//            .store(in: &cancellable)
//    }
//}
//
//// MARK: - Button Actions
//extension MenuBarView {
//    func selectItem(at index: Int) {
//        animateIndicator(to: index)
//    }
//
//    func scrollIndicator(to contentOffset: CGPoint) {
//        let buttons = [myListButton, opinionsButton]
//        let index = Int(contentOffset.x / frame.width)
//        setAlpha(for: buttons[index])
//    }
//
//    private func setAlpha(for button: UIButton) {
//        myListButton.setTitleColor(.gdacLightGray, for: .normal)
//        opinionsButton.setTitleColor(.gdacLightGray, for: .normal)
//        button.setTitleColor(.gdacBlue, for: .normal)
//    }
//
//    private func animateIndicator(to index: Int) {
//        var button: UIButton
//        switch index {
//        case 0:
//            button = myListButton
//        case 1:
//            button = opinionsButton
//        default:
//            button = myListButton
//        }
//        setAlpha(for: button)
//    }
//}
//
//// MARK: - Setup UI
//extension MenuBarView {
//    private func setupUI() {
//        setAlpha(for: myListButton)
//
//        backgroundColor = .systemBackground
//
//        let horizontalPadding: CGFloat = 16
//        let buttonSpace: CGFloat = 36
//
//        addSubviews(
//            myListButton,
//            opinionsButton,
//            separator
//        )
//
//        NSLayoutConstraint.activate([
//            myListButton.centerYAnchor.constraint(equalTo: centerYAnchor),
//            myListButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
//
//            opinionsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
//            opinionsButton.leadingAnchor.constraint(equalTo: myListButton.trailingAnchor, constant: buttonSpace),
//
//            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
//            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
//            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
//        ])
//    }
//}

final class MenuBarView: UIView {
    private let alignment: UIStackView.Alignment
    
    //MARK: - Init
    init(
        buttons: [UIButton],
        alignment: UIStackView.Alignment = .fill
    ) {
        self.buttons = buttons
        self.alignment = alignment
        super.init(frame: .zero)
        setupUI()
    }
    
    private var buttons = [UIButton]()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectItem(at index: Int) {
        setAlpha(for: buttons[index])
    }
    
    func scrollIndicator(to contentOffset: CGPoint) {
        let index = Int(contentOffset.x / frame.width)
        setAlpha(for: buttons[index])
    }
    
    private func setAlpha(for button: UIButton) {
        buttons.forEach { button in
            button.setTitleColor(.gdacLightGray, for: .normal)
        }
        button.setTitleColor(.gdacBlue, for: .normal)
    }
    
    private func setupUI() {
        setAlpha(for: buttons[0])
        
        backgroundColor = .systemBackground
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.spacing = 16
        
        let totalSv = UIStackView(arrangedSubviews: [sv])
        totalSv.axis = .vertical
        totalSv.distribution = .fill
        totalSv.alignment = alignment
        
        addSubviews(totalSv)
        
        NSLayoutConstraint.activate([
            totalSv.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalSv.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalSv.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
