//
//  MindfulApp.swift
//  Mindful
//
//  Created by Alisa Kane on 21/03/2021.
//

import SwiftUI

@main
struct MindfulApp: App {
    @StateObject var user = User()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(user)
        }
    }
}
