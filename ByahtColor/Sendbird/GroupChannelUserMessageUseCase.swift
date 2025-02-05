//
//  GroupChannelInputUseCase.swift
//  CommonModule
//
//  Created by Ernest Hong on 2022/02/10.
//

import Foundation
import SendbirdChatSDK

open class GroupChannelUserMessageUseCase {

    public let channel: GroupChannel

    public init(channel: GroupChannel) {
        self.channel = channel
    }
    
    // 선정 시에 사용
//    private func testAPI(){
//        let params = GroupChannelCreateParams()
//        params.name = "test Chat"
//
//        let server: String = "admin"
//        let client: String = "122103222308475276"
//        params.userIds = [server, client]
//        params.isDistinct = true
//
//        GroupChannel.createChannel(params: params) { channel, error in
//            guard error == nil else {
//                // Handle error.
//                return
//            }
//            let timestampStorage = TimestampStorage()
//            self.sendToImageMessage(channel: channel!)
//            self.sendToMessage(channel: channel!)
//        }
//    }
    public func sendToImageMessage(channel: GroupChannel, message: String ,data: String){
        let params = UserMessageCreateParams(message: message)
        
        params.customType = "campaignImage_with_text"
        params.data = data
        channel.sendUserMessage(params: params){ message, error in
            
        }
    }
    
    public func sendToImageMessage(channel: GroupChannel, message: String){
        let params = UserMessageCreateParams(message: message)
        channel.sendUserMessage(params: params){ message, error in
            
        }
    }
    
    open func sendMessage(_ message: String, completion: @escaping (Result<UserMessage, SBError>) -> Void) -> UserMessage? {
        let params = UserMessageCreateParams(message: message)
        return channel.sendUserMessage(params:params){ message, error in
        
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let message = message else { return }
            
            completion(.success(message))
        }
    }

    open func resendMessage(_ message: UserMessage, completion: @escaping (Result<BaseMessage, SBError>) -> Void) {
        channel.resendUserMessage(message) { message, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let message = message else { return }

            completion(.success(message))
        }
    }

    open func updateMessage(_ message: UserMessage, to newMessage: String, completion: @escaping (Result<UserMessage, SBError>) -> Void) {
        let params = UserMessageUpdateParams(message: newMessage)

        channel.updateUserMessage(messageId: message.messageId, params: params) { message, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let message = message else { return }

            completion(.success(message))
        }
    }

    open func deleteMessage(_ message: BaseMessage, completion: @escaping (Result<Void, SBError>) -> Void) {
        channel.deleteMessage(message) { error in
            if let error = error {
                completion(.failure(error))
                return
            }

            completion(.success(()))
        }
    }

}
