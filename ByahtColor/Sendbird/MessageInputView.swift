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
        textView.text = "messageInputView_placeholder".localized
        textView.textColor = UIColor(hex: "#B5B8C2")
        textView.backgroundColor = UIColor(hex: "#F4F5F8")
        textView.delegate = self
        textView.isScrollEnabled = false
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
//
//        addSubview(sendFileMessageButton)
//        sendFileMessageButton.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(10)
//            make.centerY.equalToSuperview()
//            make.width.height.equalTo(34)
//        }

        textView.delegate = self

        addSubview(textFieldContainerView)
        textFieldContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(40).priority(.high)
            textFieldContainerViewHeightConstraint = make.height.equalTo(40).constraint
        }

        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.equalTo(textFieldContainerView.snp.leading).offset(12)
            make.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-12)
            make.top.equalTo(textFieldContainerView.snp.top)
            make.bottom.equalTo(textFieldContainerView.snp.bottom)

            textViewHeightConstraint = make.height.equalTo(40).constraint
        }

        addSubview(sendUserMessageButton)
        sendUserMessageButton.snp.makeConstraints { make in
            make.leading.equalTo(textFieldContainerView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
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
        let maxHeight: CGFloat = 40 * 4  // 최대 높이 (4줄)

        textView.isScrollEnabled = estimatedSize.height > maxHeight
        textViewHeightConstraint?.update(offset: min(estimatedSize.height, maxHeight))
        textFieldContainerViewHeightConstraint?.update(offset: min(estimatedSize.height, maxHeight))
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
        updateTextViewHeight()
        delegate?.messageInputView(self, didStartTyping: textView)
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        delegate?.messageInputView(self, didChangeHeight: newSize.height + 16)
    }
}
