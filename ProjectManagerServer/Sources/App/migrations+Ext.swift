//
//  migrations+Ext.swift
//  
//
//  Created by 김민성 on 2021/08/04.
//
import Vapor
import Fluent

extension CreateTask: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("state", as: String.self, is: .in("todo", "doing", "done"), required: false)
    }
}
