//
//  Validate.swift
//  MyFramework
//
//  Created by JT on 2017/6/30.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation
/*
    from http://blog.csdn.net/h643342713/article/details/54292935
 */

//只能为中文
func onlyInputChineseCharacters(_ string: String) -> Bool {
    let inputString = "[\u{4e00}-\u{9fa5}]+"
    
    let predicate = NSPredicate(format: "SELF MATCHES %@", inputString)
    let Chinese = predicate.evaluate(with: string)
    return Chinese
}

//只能为数字
func onlyInputTheNumber(_ string: String) -> Bool {
    let numString = "[0-9]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", numString)
    let number = predicate.evaluate(with: string)
    return number
}

//只能为小写
func onlyInputLowercaseLetter(_ string: String) -> Bool {
    let regex = "[a-z]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let letter = predicate.evaluate(with: string)
    return letter
}

//只能为大写
func onlyInputACapital(_ string: String) -> Bool {
    let regex = "[A-Z]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let capital = predicate.evaluate(with: string)
    return capital
}

//允许大小写
func inputCapitalAndLowercaseLetter(_ string: String) -> Bool {
    let regex = "[a-zA-Z]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let inputString = predicate.evaluate(with: string)
    return inputString
}

//允许大小写或数字(不限字数)
func inputLettersOrNumbers(_ string: String) -> Bool {
    let regex = "[a-zA-Z0-9]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let inputString = predicate.evaluate(with: string)
    return inputString
}

//允许大小写或数字(限字数)
func inputNumberOrLetters(_ name: String) -> Bool {
    let userNameRegex = "^[A-Za-z0-9]{6,20}+$"
    let userNamePredicate = NSPredicate(format: "SELF MATCHES %@", userNameRegex)
    let inputString = userNamePredicate.evaluate(with: name)
    return inputString
}

//允许汉字，大小写或数字(限字数)
func inputChineseOrLettersNumberslimit(_ string: String) -> Bool {
    let regex = "[\u{4e00}-\u{9fa5}]+[A-Za-z0-9]{6,20}+$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let inputString = predicate.evaluate(with: string)
    return inputString
}

//允许汉字或数字(不限字数)
func inputChineseOrNumbers(_ string: String) -> Bool {
    let regex = "[\u{4e00}-\u{9fa5}]+[0-9]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let inputString = predicate.evaluate(with: string)
    return inputString
}

//允许汉字或数字(限字数)
func inputChineseOrNumbersLimit(_ string: String) -> Bool {
    let regex = "[\u{4e00}-\u{9fa5}][0-9]{6,20}+$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let inputString = predicate.evaluate(with: string)
    return inputString
}

//允许汉字，大小写或数字(不限字数)
func inputChineseOrLettersAndNumbersNum(_ string: String) -> Bool {
    let regex = "[\u{4e00}-\u{9fa5}]+[A-Za-z0-9]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let inputString = predicate.evaluate(with: string)
    return inputString
}


//by myself



