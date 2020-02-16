//
//  MessageCellNode.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 12/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation
import AsyncDisplayKit

let kAMMessageCellNodeAvatarImageSize: CGFloat = 34

let kAMMessageCellNodeTopTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor(),
    NSFontAttributeName: UIFont.boldSystemFontOfSize(CGFloat.smallFontSize)]
let kAMMessageCellNodeContentTopTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor(),
    NSFontAttributeName: UIFont.systemFontOfSize(CGFloat.smallFontSize)]
let kAMMessageCellNodeBottomTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor(),
    NSFontAttributeName: UIFont.systemFontOfSize(11)]

class MessageCellNode: ASCellNode {
    
    private let isOutgoing: Bool
    private let topTextNode: ASTextNode?
    private let contentTopTextNode: ASTextNode?
    private let bottomTextNode: ASTextNode?
    private let bubbleNode: ASDisplayNode
    private let avatarImageSize: CGFloat
    private let avatarImageNode: ASNetworkImageNode?

    init(isOutgoing: Bool, topText: NSAttributedString?, contentTopText: NSAttributedString?, bottomText: NSAttributedString?, senderAvatarURL: NSURL?, senderAvatarImageSize: CGFloat = kAMMessageCellNodeAvatarImageSize, bubbleNode: ASDisplayNode) {
        self.isOutgoing = isOutgoing

        topTextNode = topText != nil ? ASTextNode() : nil
        topTextNode?.layerBacked = true
        topTextNode?.attributedString = topText
        topTextNode?.alignSelf = .Center

        contentTopTextNode = contentTopText != nil ? ASTextNode() : nil
        contentTopTextNode?.layerBacked = true
        contentTopTextNode?.attributedString = contentTopText
        
        avatarImageSize = senderAvatarImageSize
        avatarImageNode = avatarImageSize > 0 ? ASNetworkImageNode() : nil
        avatarImageNode?.preferredFrameSize = CGSizeMake(avatarImageSize, avatarImageSize)
        avatarImageNode?.backgroundColor = UIColor.clearColor()
        avatarImageNode?.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, UIColor.clearColor())
        avatarImageNode?.URL = senderAvatarURL
        
        self.bubbleNode = bubbleNode
        self.bubbleNode.flexShrink = true
        
        bottomTextNode = bottomText != nil ? ASTextNode() : nil
        bottomTextNode?.layerBacked = true
        bottomTextNode?.attributedString = bottomText

        super.init()
        
        if let node = topTextNode { addSubnode(node) }
        if let node = contentTopTextNode { addSubnode(node) }
        if let node = avatarImageNode { addSubnode(node) }
        addSubnode(bubbleNode)
        if let node = bottomTextNode { addSubnode(node) }
        
        selectionStyle = .None
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var array: [ASLayoutable?]!
        if isOutgoing {
            array = [bubbleNode, avatarImageNode]
        }
        else {
            array = [avatarImageNode, bubbleNode]
        }
        
        let child : ASInsetLayoutSpec? = contentTopTextNode == nil ? nil : ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 22 + avatarImageSize, 0, 0), child: contentTopTextNode!)
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(1, 4, 1, 4),
            child: ASStackLayoutSpec(
                direction: .Vertical,
                spacing: 0,
                justifyContent: .Start, // Never used
                alignItems: isOutgoing ? .End : .Start,
                children: Array.filterNils([
                    topTextNode,
                    child,
                    ASStackLayoutSpec(
                        direction: .Horizontal,
                        spacing: 2,
                        justifyContent: .Start, // Never used
                        alignItems: .End,
                        children: Array.filterNils(array)),
                    bottomTextNode])))
    }
    
}

private extension Array {
    
    // Credits: http://stackoverflow.com/a/28190873/1136669
    static func filterNils(array: [Element?]) -> [Element] {
        return array.filter { $0 != nil }.map { $0! }
    }
    
}
