//
//  MessageInputView.swift
//  ByahtColor
//
//  Created by jaem on 7/23/24.
//
import UIKit
import SnapKit

public protocol MessageInputViewDelegate: AnyObject {
    func messageInputView(_ messageInputView: MessageInputView, didTouchSendFileMessageButton sender: UIButton)
    func messageInputView(_ messageInputView: MessageInputView, didTouchUserMessageButton sender: UIButton, message: String)
    func messageInputView(_ messageInputView: MessageInputView, didStartTyping sender: UITextView)
    func messageInputView(_ messageInputView: MessageInputView, didEndTyping sender: UITextView)
    func messageInputView(_ messageInputView: MessageInputView, didChangeHeight newHeight: CGFloat)
}

extension MessageInputViewDelegate {
    public func messageInputView(_ messageInputView: MessageInputView, didStartTyping sender: UITextView) { }
    public func messageInputView(_ messageInputView: MessageInputView, didEndTyping sender: UITextView) { }
}

// MARK: - MessageInputView

public class MessageInputView: UIView {

    private lazy var sendFileMessageButton: UIButton = {
        let sendFileMessageButton: UIButton = UIButton()
        sendFileMessageButton.setImage(UIImage(named: "icon_plus"), for: .normal)
        sendFileMessageButton.addTarget(self, action: #selector(didTouchSendFileMessageButton), for: .touchUpInside)
        sendFileMessageButton.isHidden = true
        return sendFileMessageButton
    }()

    private lazy var textFieldContainerView: UIView = {
        let textFieldContainerView = UIView()
        textFieldContainerView.backgroundColor = UIColor(hex: "#F4F5F8")
        textFieldContainerView.layer.cornerRadius = 16
        textFieldContainerView.clipsToBounds = true
        return textFieldContainerView
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Pretendard-Regular", size: 14)
        textView.textColor = UIColor(hex: "#B5B8C2")
        textView.backgroundColor = UIColor(hex: "#F4F5F8")
        textView.delegate = self
        textView.isScrollEnabled = false

        // Placeholder 텍스트와 LineHeight 적용
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.09 // 원하는 LineHeight 설정
        paragraphStyle.alignment = .left // 텍스트 정렬 (선택 사항)

        let attributedString = NSAttributedString(
            string: "messageInputView_placeholder".localized,
            attributes: [
                .font: UIFont(name: "Pretendard-Regular", size: 14)!,
                .foregroundColor: UIColor(hex: "#B5B8C2"),
                .paragraphStyle: paragraphStyle
            ]
        )
        textView.attributedText = attributedString

        return textView
    }()


    private lazy var sendUserMessageButton: UIButton = {
        let sendUserMessageButton: UIButton = UIButton()
        if let image = UIImage(named: "icon_submit")?.withRenderingMode(.alwaysTemplate) {
            sendUserMessageButton.setImage(image, for: .normal)
        }
        sendUserMessageButton.tintColor = UIColor(hex: "#B5B8C2") // 원하는 색상으로 변경
        sendUserMessageButton.addTarget(self, action: #selector(didTouchUserMessageButton), for: .touchUpInside)
        return sendUserMessageButton
    }()

    public weak var delegate: MessageInputViewDelegate?

    private var textViewHeightConstraint: Constraint?
    private var textFieldContainerViewHeightConstraint: Constraint?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        // textFieldContainerView 먼저 추가
        addSubview(textFieldContainerView)
        textFieldContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(5)
        }

        // sendFileMessageButton (플러스 버튼)은 따로 넣어도 되고 별도 처리할 수도 있음 (지금은 무시)

        // textView를 textFieldContainerView 안에 추가
        textFieldContainerView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().offset(-50) // 버튼 공간 남기기 (대략)
        }

        // sendUserMessageButton도 textFieldContainerView 안에 추가
        textFieldContainerView.addSubview(sendUserMessageButton)
        sendUserMessageButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTouchSendFileMessageButton(_ sender: UIButton) {
        delegate?.messageInputView(self, didTouchSendFileMessageButton: sender)
    }

    @objc private func didTouchUserMessageButton(_ sender: UIButton) {
        guard let message = textView.text, !message.isEmpty, message != "messageInputView_placeholder".localized else { return }
        textView.text = ""
        textView.textColor = UIColor(hex: "#B5B8C2")
        sendUserMessageButton.tintColor = UIColor(hex: "#B5B8C2")
        delegate?.messageInputView(self, didTouchUserMessageButton: sender, message: message)
        updateTextViewHeight()
    }

    private func updateTextViewHeight() {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        let maxTextViewHeight: CGFloat = 48 * 4 - 24  // 텍스트뷰 최대 높이 (전체 4줄 기준, 인셋 제외)

        let finalTextViewHeight = min(estimatedSize.height, maxTextViewHeight)

        textView.isScrollEnabled = estimatedSize.height > maxTextViewHeight

        textViewHeightConstraint?.update(offset: finalTextViewHeight)

        // textView 높이에 +24 (top 12 + bottom 12) 더해서 container 높이 업데이트
        textFieldContainerViewHeightConstraint?.update(offset: finalTextViewHeight + 24)

        layoutIfNeeded()
    }
}

extension MessageInputView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(hex: "#B5B8C2") {
            textView.text = ""
            textView.textColor = .black
        }
        delegate?.messageInputView(self, didStartTyping: textView)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "messageInputView_placeholder".localized
            textView.textColor = UIColor(hex: "#B5B8C2")
        }
        delegate?.messageInputView(self, didEndTyping: textView)
        updateTextViewHeight()
    }

    public func textViewDidChange(_ textView: UITextView) {
        if textView.textColor == UIColor(hex: "#B5B8C2") {
            textView.text = ""
            textView.textColor = .black
        }

        if !textView.text.isEmpty {
            sendUserMessageButton.isEnabled = true
            sendUserMessageButton.tintColor = UIColor(hex: "#009BF2")
        } else {
            sendUserMessageButton.isEnabled = false
            sendUserMessageButton.tintColor = UIColor(hex: "#B5B8C2")
        }

        
        delegate?.messageInputView(self, didStartTyping: textView)
            
            // Calculate new size
            let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
            
            // Pass only the height
            delegate?.messageInputView(self, didChangeHeight: newSize.height + 10)
        updateTextViewHeight()
        
        
    }
}
