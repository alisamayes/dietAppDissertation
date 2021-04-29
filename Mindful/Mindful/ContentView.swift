//
//  ContentView.swift
//  Mindful
//
//  Created by Alisa Kane on 21/03/2021.
//

import SwiftUI
import UserNotifications

class User: ObservableObject {
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var goalsCompleted: Double = 0.0
    
}

struct ContentView: View {
    @StateObject var user = User()
    @State private var password: String = ""
    var body: some View {
        NavigationView{
            VStack {
                
                Spacer()
                
                Image("Mindful Temp")
                    .resizable()
                    .aspectRatio(contentMode:.fit)

                Text("Welcome to Mindful").padding()
                
                Spacer()
                
                
                Form{
                    Section{
                        TextField("Username", text:$user.name)
                    }
                    Section{
                        TextField("Password", text:$password)
                    }
                }
                
                Button("Allow Notifications - Please Press"){
                    UNUserNotificationCenter.current()
                        .requestAuthorization(options: [.alert, .badge, .sound]){ success, error in
                            if success {
                                print("Granted")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    
                }
                
                NavigationLink(destination: HomeView()){
                    Text("Login")
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius:22)
                                    .stroke(Color(red: 0.3, green: 1.0, blue: 0.3), lineWidth:2))
                        .padding()
                }
            }
        }.accentColor(Color(red: 0.2, green: 0.6, blue: 0.2))
        .environmentObject(user)
    }
}
        
struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selection: String? = nil
    @EnvironmentObject var user: User
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    NavigationLink(destination: MealsView(), tag: "Meals", selection:$selection){ EmptyView() }
                    NavigationLink(destination: GoalsView(), tag: "Goals", selection:$selection){ EmptyView()}
                    NavigationLink(destination: FriendsView(), tag: "Friends", selection:$selection){ EmptyView() }
                    NavigationLink(destination: InfoView(), tag: "Info", selection:$selection){ EmptyView() }
                    
                    Button("Meals"){
                        self.selection = "Meals"
                    }
                    Button("Goals"){
                        self.selection = "Goals"
                    }
                    Button("Friends"){
                        self.selection = "Friends"
                    }
                    Button("Info"){
                        self.selection = "Info"
                    }
                }
                
                Spacer()
                
                Text("Welcome back \(user.name). Keep up the good work!")
                
                Text("Your next planned meal is at (connect time from meals tab). Go to the meals tab for more information")
                          
                Text("Your next planned shop is at (connect time from meals tab. Go to the meals tab for more information")
                           
                Spacer()
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct MealsView: View {
    @EnvironmentObject var user: User
    @State private var isPresentedB: Bool = false
    @State private var isPresentedL: Bool = false
    @State private var isPresentedD: Bool = false
    @State private var isPresentedS: Bool = false
    
    @State private var currentDate = Date()
    @State private var breakfastTime = Date()
    @State private var lunchTime = Date()
    @State private var dinnerTime = Date()
    
    @State private var breakfastPlan: String = ""
    @State private var lunchPlan: String = ""
    @State private var dinnerPlan: String = ""
    
    @State private var shoppingList = [String]()
    @State private var shoppingItem: String = ""
    
    private let defaults = UserDefaults.standard
    
    
    var body: some View {
        ZStack{
            
            ScrollView {
                VStack{
                    
                    Text("Here you can plan out your meals for the week, plan on when to have them and figure out what you need for ingridients to make these meals.")
                    
                    //BREAKFAST START
                    Group{//Grouped so they can all fit inside the VStack 10-item limit
                        HStack{
                            Text("Breakfast")
                            
                            Button("Add"){
                                self.isPresentedB = true
                            }
                            
                            DatePicker("Time", selection: $breakfastTime, displayedComponents: .hourAndMinute)
                            
                            Button("Notification"){
                                scheduleNotification(mealType: "B")
                            }.padding()
                        }
                        
                        Text(breakfastPlan)
                    }
                    //BREAKFAST END
                        
                    //LUNCH START
                    Group{
                        HStack{
                            Text("Lunch")
                            Button("Add"){
                                self.isPresentedL = true
                            }

                            DatePicker("Time", selection: $lunchTime, displayedComponents: .hourAndMinute)
                            
                            Button("Notification"){
                                scheduleNotification(mealType: "L")
                            }.padding()
                        }
                        Text(lunchPlan)
                    }
                    //LUNCH END
                        
                    //DINNER START
                    Group{
                        HStack{
                            Text("Dinner")
                            Button("Add"){
                                self.isPresentedD = true
                            }
                    
                            DatePicker("Time", selection: $dinnerTime, displayedComponents: .hourAndMinute)
                        
                            Button("Notification"){
                                scheduleNotification(mealType: "D")
                            }.padding()
                        }
                        
                        Text(dinnerPlan)
                    }
                    //DINNER END
                    
                    
                    Text("")
                    
                    Text("Now that you have your meals planned out you can make a shopping list for the week so you know what to need. Also set a time so you can make sure youve planned ahead and have the tiem set aside")
                    
                    HStack {
                        Button("Add Item"){
                            self.shoppingItem = ""
                            self.isPresentedS = true
                        }.padding()
                        
                        Spacer()
                    
                        Button("Clear"){
                            self.shoppingList.removeAll()
                            defaults.set(shoppingList, forKey: "Shop")
                        }.padding()
                    }
                    
                    ForEach(shoppingList, id: \.self){ item in
                        Text(item)
                    }
                }.padding()
            }
            
            TextFieldPopup(title: "Add Breakfast",isShown: $isPresentedB, text: $breakfastPlan, onDone: { text in
                defaults.set(breakfastPlan, forKey: "Breakfast")
            })
            
            TextFieldPopup(title: "Add Lunch",isShown: $isPresentedL, text: $lunchPlan, onDone: { text in
                defaults.set(lunchPlan, forKey: "Lunch")
            })
            
            TextFieldPopup(title: "Add Dinner",isShown: $isPresentedD, text: $dinnerPlan, onDone: { text in
                defaults.set(dinnerPlan, forKey: "Dinner")
            })
            
            TextFieldPopup(title: "Add Shopping Item",isShown: $isPresentedS, text: $shoppingItem, onDone: { text in
                self.shoppingList.append(shoppingItem)
                defaults.set(shoppingList, forKey: "Shop")
            })
            
        }
        .onAppear{
            let savedBreakfast = defaults.string(forKey: "Breakfast")
            let savedLunch = defaults.string(forKey: "Lunch")
            let savedDinner = defaults.string(forKey: "Dinner")
            let savedShopping = defaults.object(forKey: "Shop") as? [String] ?? []
            
            breakfastPlan = savedBreakfast ?? ""
            lunchPlan = savedLunch ?? ""
            dinnerPlan = savedDinner ?? ""
            shoppingList = savedShopping
        }
    }
    
    func scheduleNotification(mealType: String){
        
        let Notif = UNMutableNotificationContent()
        var Trigger: UNCalendarNotificationTrigger
        //var Trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        if mealType == "B" {
            Notif.title = "Get Breakfast"
            Notif.body = breakfastPlan
            let notifDate = Calendar.current.dateComponents([.hour, .minute], from: breakfastTime)
            Trigger = UNCalendarNotificationTrigger(dateMatching: notifDate, repeats: true)
        }
        else if mealType == "L"{
            Notif.title = "Get Lunch"
            Notif.body = "Meal: \(lunchPlan), Time:\(lunchTime)"
            let notifDate = Calendar.current.dateComponents([.hour, .minute], from: lunchTime)
            Trigger = UNCalendarNotificationTrigger(dateMatching: notifDate, repeats: true)
        }
        else  if mealType == "D" {
            Notif.title = "Get Dinner"
            Notif.body = dinnerPlan
            let notifDate = Calendar.current.dateComponents([.hour, .minute], from: dinnerTime)
            Trigger = UNCalendarNotificationTrigger(dateMatching: notifDate, repeats: true)
        }
        else {
            Notif.title = "Shopping run"
            Notif.body = "Time to go get your weekly shop"
            let notifDate = Calendar.current.dateComponents([.hour, .minute], from: breakfastTime)
            Trigger = UNCalendarNotificationTrigger(dateMatching: notifDate, repeats: true)        }
        
        Notif.sound = UNNotificationSound.default
        let Request = UNNotificationRequest(identifier: UUID().uuidString, content: Notif, trigger: Trigger)
        
        UNUserNotificationCenter.current().add(Request)
        
        print("Notification button pressed")
        print("Times wanted is ", breakfastTime)    }
}

struct GoalsView: View {
    @EnvironmentObject var user: User
    
    @State private var stg: String = ""
    @State private var isPresentedStg: Bool = false
    @State private var ltg: String = ""
    @State private var isPresentedLtg: Bool = false
    
    @State private var goalsTarget = 10.0
    //@State private var goalsPercent: Double
    
    private let defaults = UserDefaults.standard
    
    
    var body: some View {
        
        ZStack{
            if user.goalsCompleted < 3.0 {
                LinearGradient(gradient: Gradient(colors: [.orange, .red ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else if user.goalsCompleted < 7.0 {
                LinearGradient(gradient: Gradient(colors: [.orange, Color(.systemTeal) ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else {
              LinearGradient(gradient: Gradient(colors: [.green, Color(.systemTeal) ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            
            Rectangle()
                .fill(Color.white)
                .padding()
                .ignoresSafeArea()
           
           VStack{
            Text("Here you can set yourself personal short and long term goals to help improve your eating behaviorus at your own pace").padding()
               
                               
            HStack{
                Text("Short term goal").padding()
                   
                Spacer()
                   
                   
                Button(action: {
                    self.isPresentedStg = true
                }) {
                    Text("Set").padding()
                }
                
                Button(action:{
                    user.goalsCompleted = user.goalsCompleted + 1
                    stg = ""
                    defaults.set(user.goalsCompleted, forKey: "goalsCompleted")
                }) {
                    Text("Accomplished").padding()
                }
            }
            
            Text(stg)
            
            Spacer()
            
            HStack{
                Text("Long term goals").padding()
                
                Spacer()
                
                Button(action: {
                    self.isPresentedLtg = true
                }) {
                    Text("Set").padding()
                }
                
                Spacer()
                Spacer()
                
                Button(action:{
                    user.goalsCompleted = user.goalsCompleted + 1
                    ltg = ""
                    defaults.set(user.goalsCompleted, forKey: "goalsCompleted")
                    defaults.set(ltg, forKey: "Ltg")
                }) {
                    Text("Accomplished").padding()
                }
            }
            
            Text(ltg)
            
            Spacer()
                   
           //Try and see if a graph for goals:days can be added
            HStack {
                Text("Great work \(user.name). So far you have completed \(Int(user.goalsCompleted)) of your goals this week. Keep at it, you're doing great").padding()
               
                Button("R"){
                    user.goalsCompleted = 0.0
                    defaults.set(user.goalsCompleted, forKey: "goalsCompleted")
                }.padding()
            }
            
            ProgressView("Goals Target", value: user.goalsCompleted, total: goalsTarget).padding()
           }.padding()
                   
                   
           TextFieldPopup(title: "Add Short Term Goal",isShown: $isPresentedStg, text: $stg, onDone: { text in
               defaults.set(stg, forKey: "Stg")
           })
           TextFieldPopup(title: "Add Long Term Goal",isShown: $isPresentedLtg, text: $ltg, onDone: { text in
               defaults.set(ltg, forKey: "Ltg")
           })
       }.onAppear{
            let savedStg = defaults.string(forKey: "Stg")
            let savedLtg = defaults.string(forKey: "Ltg")
            let savedCompleted = defaults.double(forKey: "goalsCompleted")
            
            stg = savedStg ?? ""
            ltg = savedLtg ?? ""
            user.goalsCompleted = savedCompleted
       }
    }
}

struct FriendsView: View {
    @EnvironmentObject var user: User
    
    @State private var isPresented: Bool = false
    @State private var goalsCompleted = 0.0
    @State private var communityGoalTarget = 50.0
    
    var myFriends = [
        Friend(id: 1, name: "Harry", goals: "2"),
        Friend(id: 2, name: "Amy", goals: "5"),
        Friend(id: 3, name: "Peter", goals: "6"),
        Friend(id: 4, name: "Katie", goals: "7"),
        Friend(id: 5, name: "Tom", goals: "3")
    ]
    
    private let defaults = UserDefaults.standard
    
    var body: some View {
        ZStack {
            
            if self.goalsCompleted < 20.0 {
                LinearGradient(gradient: Gradient(colors: [.orange, .red ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else if self.goalsCompleted < 40.0 {
                LinearGradient(gradient: Gradient(colors: [.orange, Color(.systemTeal) ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else {
              LinearGradient(gradient: Gradient(colors: [.green, Color(.systemTeal) ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            
            Rectangle()
                .fill(Color.white)
                .padding()
                .ignoresSafeArea()
    
            VStack{
                
                Text("Here you and your friends can work together to set a  comminity goal and a community goal target. Work togehter to complete these and improve everyones health").padding()
                    
                
                Text("Friends List").font(.title)
                
                HStack{
                    Text("Name").padding(.horizontal)
                    Spacer()
                    Text("Goals Completed").padding(.horizontal)
                }
                FriendList(friends: myFriends)
                
                Spacer()
                
                Text("Work together with your friends to eat a 100 pieces of fruit this week")
                
                HStack{
                    Text("Community Goals")
                    
                    Button(action:{
                        goalsCompleted = goalsCompleted + 1
                        defaults.set(goalsCompleted, forKey: "completed")
                    }) {
                        Text("+")
                            .padding()
                    }
                    
                    Button(action:{
                        goalsCompleted = 0.0
                        defaults.set(goalsCompleted, forKey: "completed")
                    }) {
                        Text("R")
                            .padding()
                    }
                    
                }
                
                ProgressView("Goals Target", value: goalsCompleted, total: communityGoalTarget).padding()
            }.padding()
        }.onAppear{
            let savedCompleted = defaults.double(forKey: "completed")
            goalsCompleted = savedCompleted
        }
    }
}
    

struct InfoView: View {
    
    @EnvironmentObject var user: User
    
    var body: some View {
        
        
        ScrollView{
            VStack(alignment: .leading) {
                Text("Benefits to staying healthy")
                    .font(.title)
                Text("Our food provides us with the energy we need to run, grow and repair. Maintiang a healthy diet is important to avoid negative health effects such as diabetes, obesity and many more. It also can have an impact on our mental health and good, healthy diets are shown to have a positive effect.")
            
            
            
                Text("Tips to a healthy diet")
                    .font(.title)
                Text("Eat 5 of your fruit and veg daily.  Avoid eating to much or too little each day. Make sure you have a good balance of food groups. While snacking can be healthy, make sure you consume only good snacks such as fruit, nuts and similar and avoids bad ones such as sweets and crisp. Try to develop a routine for when to eat which will assit controlling hunger.")
            
                Text("Aims of project")
                    .font(.title)
                Text("The aim of this project is to see if persuasive technology can help users to move towards healthier eating behaviours by targeting key identified obstacles. It will use technuiqes such as reinforcement, promts, facilitators and so on.")
            
                Text("Disclaimers and Contact Info ")
                    .font(.title)
                Text("Firstly thank you so much for agreeing to take part in this study. I just want to make you aware that if for any reason you feel as if you are unable to complete it then that is ok. It is entirely voulantary and you can stop when ever you want, just please let me know.")
                Text("Email: am240@bath.ac.uk")
                
            }
            .padding(.all)
        }
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 8 Plus")
            ContentView()
                .previewDevice("iPhone 8 Plus")
        }
    }
}
