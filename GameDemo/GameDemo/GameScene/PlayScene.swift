//
//  File.swift
//  GameDemo
//
//  Created by Goko on 15/08/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class PlayScene: SKScene{
    
    private let rowCount:Int = 8
    
    private var squareLength:CGFloat = 0.0
    private var squareSize:CGSize = CGSize.init()
    private var backgroundOrigin:CGPoint = CGPoint.init()
    private var colorFullSquares:[SKSpriteNode] = []
//    private var dealQueue:DispatchQueue
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.gray
        initialData()
        addBackground()
        addSquare()
        
    }
    func initialData() -> Void {
        let width:CGFloat = self.size.width
        let height = self.size.height
        squareLength = width / CGFloat.init(rowCount)
        squareSize = CGSize.init(width: squareLength, height: squareLength)
        backgroundOrigin = CGPoint.init(x: 0, y: height / 2 - squareLength * CGFloat.init(rowCount) / 2)
    }
    func addBackground() -> Void {
        var node:SKSpriteNode
        for i in 0...rowCount {
            for j in 0...rowCount{
                if (i % 2 == 0 && j % 2 == 0) || (i % 2 == 1 && j % 2 == 1){
                    node = SKSpriteNode.init(color: SKColor.lightGray, size: squareSize)
                }else{
                    node = SKSpriteNode.init(color: SKColor.white, size: squareSize)
                }
                // 4.2 设置棋盘格的位置
                node.position = CGPoint.init(x: backgroundOrigin.x + squareLength / 2 + squareLength * CGFloat.init(j),
                                             y: backgroundOrigin.y + squareLength / 2 + squareLength * CGFloat.init(i))
                node.name = "backSquare"
                self.addChild(node)
            }
        }
    }
    
    func addSquare() -> Void {
        // 1 设置彩色方砖的长度
        let colorSquare:CGFloat = squareLength - 5.0
        
        var index:Int = 0
        var node:SKSpriteNode
        for i in 0...rowCount {
            for j in 0...rowCount{
                // 2 产生随机数对6求余， 结果会有0，1，2，3，4，5，保证有1/6的
                index = Int.init(arc4random() % 6)
                if index == 5 {
                    continue
                }
                switch(index){
                case 0:
                    node = SKSpriteNode.init(color: SKColor.yellow, size: CGSize.init(width: colorSquare, height: colorSquare))
                case 1:
                    node = SKSpriteNode.init(color: SKColor.magenta, size: CGSize.init(width: colorSquare, height: colorSquare))
                case 2:
                    node = SKSpriteNode.init(color: SKColor.orange, size: CGSize.init(width: colorSquare, height: colorSquare))
                case 3:
                    node = SKSpriteNode.init(color: SKColor.purple, size: CGSize.init(width: colorSquare, height: colorSquare))
                case 4:
                    node = SKSpriteNode.init(color: SKColor.brown, size: CGSize.init(width: colorSquare, height: colorSquare))
                default:
                    node = SKSpriteNode.init(color: SKColor.black, size: CGSize.init(width: colorSquare, height: colorSquare))
                }
                
                // 4 指定节点的位置，并将彩色方砖的位置和颜色信息存入node的userData字段中去了。
                let positionX = backgroundOrigin.x + squareLength / 2 + squareLength * CGFloat.init(j)
                let positionY = backgroundOrigin.y + squareLength / 2 + squareLength * CGFloat.init(i)
                node.position = CGPoint.init(x: positionX, y: positionY)
                let userData:Dictionary<String,Any> = ["nodeType":"colorSquare",
                                                       "position":node.position,
                                                       "color":node.color,
                                                       "exsit":true]
                node.userData = NSMutableDictionary.init(dictionary: userData)
                
                // 5 设置节点的名字，并加入到scene场景。
                node.name = "colorSquare";
                self.colorFullSquares.append(node)
                self.addChild(node)
            }
        }
        
    }
    func findFourDirectionSquareNode(node:SKNode) -> Array<SKNode> {
        var tempArray:Array<SKNode> = []
        let position:CGPoint = node.userData?.object(forKey: "position") as! CGPoint
        // 2 获取游戏界面中，最小位置（左下）和最大位置（右上），作为边界
        let tempLength = squareLength / CGFloat.init(2)
        let minX = backgroundOrigin.x + tempLength
        let minY = backgroundOrigin.y + tempLength
        let maxX = backgroundOrigin.x + tempLength + squareLength * 7
        let maxY = backgroundOrigin.y + tempLength + squareLength * 7
        // 3 left 向左寻找彩色方块节点
        var x = position.x - squareLength
        while x >= minX{
            let node = self.nodes(at: CGPoint.init(x: x, y: position.y)).first
            if node != nil{
                tempArray.append(node!)
                break
            }
            x = x - squareLength
        }
        x = position.x + squareLength
        while x >= minX{
            let node = self.nodes(at: CGPoint.init(x: x, y: position.y)).first
            if node != nil{
                tempArray.append(node!)
                break
            }
            x = x - squareLength
        }
        
        return tempArray
        /*{
         
         // 3 left 向左寻找彩色方块节点
         for (CGFloat x = positionX - _SquareLength; x >= minX; x=x-_SquareLength) {
         SKNode *node = [self nodeAtPoint:CGPointMake(x, positionY)];
         if ([self isExsitColorNode:node]) {
         [tempArray addObject:node];
         break;
         }
         }
         
         // 4 right 向右寻找
         for (CGFloat x = positionX + _SquareLength; x = minY; y=y-_SquareLength) {
         SKNode *node = [self nodeAtPoint:CGPointMake(positionX , y)];
         if ([self isExsitColorNode:node]) {
         [tempArray addObject:node];
         break;
         }
         }
         
         // 6 up 向上寻找
         for (CGFloat y = positionY + _SquareLength; y <= maxY; y=y+_SquareLength) {
         SKNode *node = [self nodeAtPoint:CGPointMake(positionX , y)];
         if ([self isExsitColorNode:node]) {
         [tempArray addObject:node];
         break;
         }
         }
         
         // 7 返回结果
         return tempArray;
*/
    }
    func findSameSquareInArray(array:Array<SKNode>) -> Dictionary<String,Any> {
        return nil
    }
    func isExistColorSquareToEliminate() -> Bool {
        for i in 0...rowCount {
            for j in 0...rowCount{
                let point = CGPoint.init(x: backgroundOrigin.x + squareLength / CGFloat.init(2) + squareLength * CGFloat.init(i),
                                         y: backgroundOrigin.y + squareLength / CGFloat.init(2) + squareLength * CGFloat.init(j))
                let node:SKNode = self.nodes(at: point).first!
                if node.name == "backSquare"{
                    let tempArray:Array<SKNode> = self.findFourDirectionSquareNode(node:node)
                    let resultDic:Dictionary<String,Any> = self.findSameSquareInArray(array: tempArray)
                    for (key,value) in resultDic{
                        let array:Array<Any> = value as! Array
                        if array.count > 1{
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
}
