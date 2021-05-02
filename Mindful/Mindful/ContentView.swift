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
    @Published var groupGoalsCompleted: Double = 0.0
    
    
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
            ScrollView {
                VStack{
                    HStack{
                        NavigationLink(destination: ScheduleView(), tag: "Schedule", selection:$selection){ EmptyView() }
                        NavigationLink(destination: PlanView(), tag: "Meal Plan", selection:$selection){ EmptyView() }
                        NavigationLink(destination: GoalsView(), tag: "Goals", selection:$selection){ EmptyView()}
                        NavigationLink(destination: FriendsView(), tag: "Friends", selection:$selection){ EmptyView() }
                        NavigationLink(destination: InfoView(), tag: "Info", selection:$selection){ EmptyView() }
                        
                        Button("Schedule"){
                            self.selection = "Schedule"
                        }
                        Button("Meal Plan"){
                            self.selection = "Meal Plan"
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
                    
                    //Spacer()
                    
                    Text("Welcome back \(user.name). Currently you have completed \(Int(user.goalsCompleted)) of you're personal goals. Head over to the Goals page to set and track these goals.")
                        .multilineTextAlignment(.center)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                    Text("Make sure you've visited the Schedule tab to plan out when and what you want for your meals of the day so that you're well prepared. You can also right plan out the shopping list and time here as well. Furthermore you can add youre planned meals in the Meal Plan tab to referance later.")
                        .multilineTextAlignment(.center)
                        .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
                              
                    Text("Check out your community goal that you can work together with friends to accomplish in the Friends tab and see how theyre doing. Currently have contributed \(Int(user.groupGoalsCompleted)) towards the community goal.")
                        .multilineTextAlignment(.center)
                        .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
                    
                    Text("For more information on how to eat healthily and information on this project please visit the Information tab.")
                        .multilineTextAlignment(.center)
                        .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
                               
                }.padding()
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct ScheduleView: View {
    @EnvironmentObject var user: User
    @State private var isPresentedB: Bool = false
    @State private var isPresentedL: Bool = false
    @State private var isPresentedD: Bool = false
    
    @State private var breakfastTime = Date()
    @State private var lunchTime = Date()
    @State private var dinnerTime = Date()
    
    @State private var breakfastPlan: String = ""
    @State private var lunchPlan: String = ""
    @State private var dinnerPlan: String = ""
    
    private let defaults = UserDefaults.standard
    
    
    var body: some View {
        ZStack{
            
            ScrollView {
                VStack{
                    
                    Text("Here you can plan out your meals for the day. Enter in your planned meals then select the time you wish to start preparing them. Press the Alert button once and a notification will be set for the time currently selected time")
                    
                    //BREAKFAST START
                    Group{//Grouped so they can all fit inside the VStack 10-item limit
                        HStack{
                            Text("Breakfast")
                            
                            Spacer()
                            
                            Button("Edit"){
                                self.isPresentedB = true
                            }
                            
                            DatePicker("",selection: $breakfastTime, displayedComponents: .hourAndMinute)
                            
                            Button("Alert"){
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
                            
                            Spacer()
                            
                            Button("Edit"){
                                self.isPresentedL = true
                            }

                            DatePicker("", selection: $lunchTime, displayedComponents: .hourAndMinute)
                            
                            Button("Alert"){
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
                            
                            Spacer()
                            
                            Button("Edit"){
                                self.isPresentedD = true
                            }
                    
                            DatePicker("", selection: $dinnerTime, displayedComponents: .hourAndMinute)
                        
                            Button("Alert"){
                                scheduleNotification(mealType: "D")
                            }.padding()
                        }
                        
                        Text(dinnerPlan)
                    }
                    //DINNER END
                    
                    
                    
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
            
            
        }
        .onAppear{
            let savedBreakfast = defaults.string(forKey: "Breakfast")
            let savedLunch = defaults.string(forKey: "Lunch")
            let savedDinner = defaults.string(forKey: "Dinner")
            
            breakfastPlan = savedBreakfast ?? ""
            lunchPlan = savedLunch ?? ""
            dinnerPlan = savedDinner ?? ""
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
        else {
            Notif.title = "Get Dinner"
            Notif.body = dinnerPlan
            let notifDate = Calendar.current.dateComponents([.hour, .minute], from: dinnerTime)
            Trigger = UNCalendarNotificationTrigger(dateMatching: notifDate, repeats: true)
        }
        
        Notif.sound = UNNotificationSound.default
        let Request = UNNotificationRequest(identifier: UUID().uuidString, content: Notif, trigger: Trigger)
        
        UNUserNotificationCenter.current().add(Request)
    }
}

struct PlanView: View {
    @EnvironmentObject var user: User
    @State private var mealsList = [String]()
    @State private var mealItem: String = ""
    @State private var isPresentedM: Bool = false
    
    @State private var isPresentedS: Bool = false
    @State private var shoppingList = [String]()
    @State private var shoppingItem: String = ""
    @State private var shoppingTime = Date()
    
    private let defaults = UserDefaults.standard
    
    var body: some View{
        ZStack{
            ScrollView {
                VStack{
                    Text("This tab will allow you to plan for the week. Please use these lists to keep note of all the meals you have planned planned and the ingridients you will neeed to make them. Furthermore you can plan out your next shopping trip by selecting a time and date and setting a notification to make sure you dont forget and put the time aside for it. ")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    HStack {
                        Button("Add Item"){
                            self.mealItem = ""
                            self.isPresentedM = true
                        }
                        
                        Spacer()
                        
                        Button("Undo"){
                            self.mealsList.popLast()
                            defaults.set(mealsList, forKey: "Meals")
                        }
                    
                        Button("Clear"){
                            self.mealsList.removeAll()
                            defaults.set(mealsList, forKey: "Meals")
                        }
                    }
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                    ForEach(mealsList, id: \.self){ item in
                        Text(item)
                    }
                    
                    Spacer()
                    Text("")
                        
                    HStack {
                        Button("Add Item"){
                            self.shoppingItem = ""
                            self.isPresentedS = true
                        }
                        
                        Spacer()
                        
                        Button("Undo"){
                            self.shoppingList.popLast()
                            defaults.set(shoppingList, forKey: "Shop")
                        }
                    
                        Button("Clear"){
                            self.shoppingList.removeAll()
                            defaults.set(shoppingList, forKey: "Shop")
                        }
                    }
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                    ForEach(shoppingList, id: \.self){ item in
                        Text(item)
                    }
                    
                    HStack{
                        DatePicker("", selection: $shoppingTime)
                        
                        Spacer()
                        
                        Button("Alert"){
                            let Notif = UNMutableNotificationContent()
                            var Trigger: UNCalendarNotificationTrigger


                            Notif.title = "Shopping run"
                            Notif.body = "Time to go get your weekly shop"
                            let notifDate = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: shoppingTime)
                            Trigger = UNCalendarNotificationTrigger(dateMatching: notifDate, repeats: true)
                            
                            
                            Notif.sound = UNNotificationSound.default
                            let Request = UNNotificationRequest(identifier: UUID().uuidString, content: Notif, trigger: Trigger)
                            
                            UNUserNotificationCenter.current().add(Request)
                        }
                    }
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }
            }
            
            TextFieldPopup(title: "Add a Meal",isShown: $isPresentedM, text: $mealItem, onDone: { text in
                self.mealsList.append(mealItem)
                defaults.set(mealsList, forKey: "Meals")
            })
            
            TextFieldPopup(title: "Add Shopping Item",isShown: $isPresentedS, text: $shoppingItem, onDone: { text in
                self.shoppingList.append(shoppingItem)
                defaults.set(shoppingList, forKey: "Shop")
            })
            
        }.onAppear{
            let savedMeals = defaults.object(forKey: "Meals") as? [String] ?? []
            let savedShopping = defaults.object(forKey: "Shop") as? [String] ?? []
            
            shoppingList = savedShopping
            mealsList = savedMeals
        }
    }
    
}

struct GoalsView: View {
    @EnvironmentObject var user: User
    
    @State private var stg: String = ""
    @State private var isPresentedStg: Bool = false
    @State private var ltg: String = ""
    @State private var isPresentedLtg: Bool = false
    
    @State private var goalsTarget = 10.0
    
    private let defaults = UserDefaults.standard
    
    
    
    
    var body: some View {
        
        ZStack{
            
            if user.goalsCompleted == 0.0 {
                LinearGradient(gradient: Gradient(colors: [.red, .red ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else if user.goalsCompleted < 3.0 {
                LinearGradient(gradient: Gradient(colors: [.red, .orange ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else if user.goalsCompleted < 5.0 {
                LinearGradient(gradient: Gradient(colors: [.yellow, .orange ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else if user.goalsCompleted < 7.0 {
                LinearGradient(gradient: Gradient(colors: [.yellow, .blue ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else if user.goalsCompleted < 9.0 {
                LinearGradient(gradient: Gradient(colors: [.green, .blue ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else if user.goalsCompleted < 10.0 {
                LinearGradient(gradient: Gradient(colors: [.green, .green ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else  {
                LinearGradient(gradient: Gradient(colors: [.green, Color(red: 0.1, green: 1.0, blue: 0.1) ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }

            Rectangle()
                .fill(Color.white)
                .padding()
                .ignoresSafeArea()
            
           

                VStack{
                    Text("Here you can set yourself personal short and long term goals to strive for to help improve your eating behaviorus at your own pace").padding([.leading, .bottom, .trailing])
                   
                Group{//Short term goal group
                    Text("Short term goal").multilineTextAlignment(.leading).padding(.horizontal)
                    HStack{
                        Button(action: {
                            self.isPresentedStg = true
                        }) {
                            Text("Set").padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        Button(action:{
                            user.goalsCompleted = user.goalsCompleted + 1
                            stg = ""
                            defaults.set(user.goalsCompleted, forKey: "goalsCompleted")
                        }) {
                            Text("Accomplished").padding(.horizontal)
                        }
                    }
                    
                    Text(stg)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                Group{
                    Text("Long term goals").multilineTextAlignment(.leading).padding([.top, .leading, .trailing])
                    HStack{
                        Button(action: {
                            self.isPresentedLtg = true
                        }) {
                            Text("Set").padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        Button(action:{
                            user.goalsCompleted = user.goalsCompleted + 1
                            ltg = ""
                            defaults.set(user.goalsCompleted, forKey: "goalsCompleted")
                            defaults.set(ltg, forKey: "Ltg")
                        }) {
                            Text("Accomplished").padding(.horizontal)
                        }
                    }
                    
                    Text(ltg)
                        .padding(.horizontal)
                }
                
                Spacer()
                       
               //Try and see if a graph for goals:days can be added
                HStack {
                    if user.goalsCompleted < 1 {
                        Text("Hello \(user.name). So far you haven't completed any of your goals this week. Make sure you've set them and keep them in mind. You can do it").padding()
                    }
                    else if user.goalsCompleted < 5 {
                        Text("Hey \(user.name). So far you have completed \(Int(user.goalsCompleted)) of your goals. It's a great start but I know you can do better. Make sure you keep at it").padding()
                    }
                    else if user.goalsCompleted < 10{
                        Text("Great work \(user.name). Currently you have accomplished \(Int(user.goalsCompleted)) of your goals this week. You're nearly there!").padding()
                    }
                    else {
                        Text("Amazing job \(user.name)! You managed to complete \(Int(user.goalsCompleted)) of your personal goals. You've done brilliantly but that doesnt mean you have to stop now so go and exceed those expectations").padding()
                    }
                        
                    Button("R"){
                        user.goalsCompleted = 0.0
                        defaults.set(user.goalsCompleted, forKey: "goalsCompleted")
                    }.padding()
                }
                
                    ProgressView("Goals Target", value: user.goalsCompleted, total: goalsTarget).padding([.leading, .bottom, .trailing])
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
    @State private var communityGoalTarget = 50.0
    @State private var friendsTotal = 9.0
    
    var myFriends = [
        Friend(id: 1, name: "Harry", goals: "2"),
        Friend(id: 2, name: "Amy", goals: "1"),
        Friend(id: 3, name: "Peter", goals: "2"),
        Friend(id: 4, name: "Katie", goals: "3"),
        Friend(id: 5, name: "Tom", goals: "1")
    ]
    
    private let defaults = UserDefaults.standard
    
    var body: some View {
        ZStack {
            
            if user.groupGoalsCompleted == 0.0 {
                LinearGradient(gradient: Gradient(colors: [.red, .red ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else if user.groupGoalsCompleted < 10.0 {
                LinearGradient(gradient: Gradient(colors: [.red, .orange ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else if user.groupGoalsCompleted < 20.0 {
                LinearGradient(gradient: Gradient(colors: [.yellow, .orange ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else if user.groupGoalsCompleted < 30.0 {
                LinearGradient(gradient: Gradient(colors: [.yellow, .blue ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else if user.groupGoalsCompleted < 40.0 {
                LinearGradient(gradient: Gradient(colors: [.green, .blue ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else if user.groupGoalsCompleted < 50.0 {
                LinearGradient(gradient: Gradient(colors: [.green, .green ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            else  {
                LinearGradient(gradient: Gradient(colors: [.green, Color(red: 0.1, green: 1.0, blue: 0.1) ]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            
            Rectangle()
                .fill(Color.white)
                .padding()
                .ignoresSafeArea()
    
            VStack{
                
                Text("Here you and your friends can work together to accomplish a larger community goal. Contribute to the to community target to improve your health together").padding([.leading, .bottom, .trailing])
                    
                
                Text("Friends List").font(.title)
                
                HStack{
                    Text("Name").padding(.horizontal)
                    Spacer()
                    Text("Goals Completed").padding(.horizontal)
                }
                FriendList(friends: myFriends)
                
                Spacer()
                
                Text("Work together with your friends to eat a 50 pieces of fruit this week. So far you have eaten \(Int(user.groupGoalsCompleted + friendsTotal)) pieces as a group")
                
                HStack{
                    Text("Community Goals")
                    
                    Button(action:{
                        user.groupGoalsCompleted = user.groupGoalsCompleted + 1
                        defaults.set(user.groupGoalsCompleted, forKey: "completed")
                    }) {
                        Text("+")
                            .padding()
                    }
                    
                    Button(action:{
                        user.groupGoalsCompleted = 0.0
                        defaults.set(user.groupGoalsCompleted, forKey: "completed")
                    }) {
                        Text("R")
                            .padding()
                    }
                    
                }
                
                ProgressView("Goals Target", value: user.groupGoalsCompleted + friendsTotal, total: communityGoalTarget).padding()
            }.padding()
        }.onAppear{
            let savedCompleted = defaults.double(forKey: "completed")
            user.groupGoalsCompleted = savedCompleted
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
