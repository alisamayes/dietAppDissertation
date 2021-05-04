//
//  FriendList.swift
//  Mindful
//
//  Created by Alisa Kane on 16/04/2021.
//

import SwiftUI

struct FriendList: View {
    var friends: [Friend]
    var body: some View {
        VStack{
            Spacer()
            List(friends){
                friend in ListRow(eachFriend: friend)
            }
            Spacer()
        }
    }
}

struct ListRow: View {
    var eachFriend: Friend
    var body: some View{
        HStack{
            Text(eachFriend.name)
            Spacer()
            Text(eachFriend.goals)
        }
    }
}

var myFriends = [
    Friend(id: 1, name: "Harry", goals: "2"),
    Friend(id: 2, name: "Amy", goals: "5"),
    Friend(id: 3, name: "Peter", goals: "6"),
    Friend(id: 4, name: "Katie", goals: "7")
]


struct FriendList_Previews: PreviewProvider {
    static var previews: some View {
        FriendList(friends: myFriends)
    }
}
