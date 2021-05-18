# This is the README File for the Mealwise IOS application which was made as the proposed solution to the accompanying project: "The use of persuasive techniques in helping change toward healthy eating behaviours"

This IOS application was written in the Swift language and uses SwiftUI as well for UI features. It was developed in Xcode

The files contained:

ContentView.swift :
This file contains the vast majority of the application. All the code for each View Controller can be found here

Friends.swift :
A smaller swift code file which handles the Friends structure used in the custom FriendsList View. This was made by following a Youtube tutorial during development and I have unfortunately been able to find and credit it

FriendsList.swift : The custom FriendsList view to correctly and cleanly display an array of name values pairs in the ContentView and generate a clean, nice looking friends list

Info.plist: This so related to Xcode and App Store signing and identifying mechanism and automatically generated

MealwiseApp.swift : The actual application itself. Simply calls the ContentView where all the code is.

TextFieldPopup.swift : This file contains the custom view TextFieldPopup as described in the dissertation. It is effectively a popup where the user can input text which is not part of the default views available to Swift.
