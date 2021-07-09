//
//  Comment.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import Foundation


struct Comment: Identifiable {
    
    
    let id = UUID()
    let writerProfile: String = [
        "user1", "user2", "user3", "user4", "user5", "user6", "user7", "user8", "user9", "user10", "user11", "user12", "user13", "user14", "user15",
        "user16", "user17", "user18", "user19", "user20", "user21", "user22", "user23", "user24", "user25", "user26", "user27", "user28", "user29", "user30"
    ].randomElement() ?? ""
    let writerName: String = [
        "Liam", "Noah", "Oliver", "Elijah", "William", "James", "Benjamin", "Lucas", "Henry", "Alexander", "Mason", "Michael", "Ethan", "Daniel", "Jacob",
        "Ella", "Luna", "Abigail", "Gianna", "Camila", "Harper", "Evelyn", "Mia", "Isabella", "Amelia", "Sophia", "Charlotte", "Ava", "Emma", "Olivia"
    ].randomElement() ?? ""
    let comment: String = [
        "Client A wants a last-minute deployment for their web service. You’re already on a tight deadline, so you decide to just make it work. All that “extra” stuff—documentation, proper commenting, and so forth—you’ll add that later.",
        "The deadline comes, and you deploy the service, right on time. Whew!",
        "You make a mental note to go back and update the comments, but before you can put it on your to-do list, your boss comes over with a new project that you need to get started on immediately. Within a few days, you’ve completely forgotten that you were supposed to go back and properly comment the code you wrote for Client A.",
        "Fast forward six months, and Client A needs a patch built for that same service to comply with some new requirements. It’s your job to maintain it, since you were the one who built it in the first place. You open up your text editor and…",
        "What did you even write?!",
        "You spend hours parsing through your old code, but you’re completely lost in the mess. You were in such a rush at the time that you didn’t name your variables properly or even set your functions up in the proper control flow. Worst of all, you don’t have any comments in the script to tell you what’s what!",
        "Developers forget what their own code does all the time, especially if it was written a long time ago or under a lot of pressure. When a deadline is fast approaching, and hours in front of the computer have led to bloodshot eyes and cramped hands, that pressure can be reflected in the form of code that is messier than usual.",
        "Once the project is submitted, many developers are simply too tired to go back and comment their code. When it’s time to revisit it later down the line, they can spend hours trying to parse through what they wrote.",
        "Writing comments as you go is a great way to prevent the above scenario from happening. Be nice to Future You!",
        "Imagine you’re the only developer working on a small Django project. You understand your own code pretty well, so you don’t tend to use comments or any other sort of documentation, and you like it that way. Comments take time to write and maintain, and you just don’t see the point.",
        "The only problem is, by the end of the year your “small Django project” has turned into a “20,000 lines of code” project, and your supervisor is bringing on additional developers to help maintain it.",
        "The new devs work hard to quickly get up to speed, but within the first few days of working together, you’ve realized that they’re having some trouble. You used some quirky variable names and wrote with super terse syntax. The new hires spend a lot of time stepping through your code line by line, trying to figure out how it all works. It takes a few days before they can even help you maintain it!",
        "Using comments throughout your code can help other developers in situations like this one. Comments help other devs skim through your code and gain an understanding of how it all works very quickly. You can help ensure a smooth transition by choosing to comment your code from the outset of a project.",
        "Now that you understand why it’s so important to comment your code, let’s go over some basics so you know how to do it properly.",
        "Comments are for developers. They describe parts of the code where necessary to facilitate the understanding of programmers, including yourself.",
        "Python ignores everything after the hash mark and up to the end of the line. You can insert them anywhere in your code, even inline with other code:",
        "When you run the above code, you will only see the output This will run. Everything else is ignored.",
        "Comments should be short, sweet, and to the point. While PEP 8 advises keeping code at 79 characters or fewer per line, it suggests a max of 72 characters for inline comments and docstrings. If your comment is approaching or exceeding that length, then you’ll want to spread it out over multiple lines.",
        "Unfortunately, Python doesn’t have a way to write multiline comments as you can in languages such as C, Java, and Go:"
    ].randomElement() ?? ""
    let upVotes: Int = (0...120).randomElement() ?? 0
    let downVotes: Int = (0...50).randomElement() ?? 0
    let comments: Int = (0...60).randomElement() ?? 0
    let views: Int = (20...4000).randomElement() ?? 20
    let date: Date = Date().addingTimeInterval(-Double((0...(7 * 24 * 60 * 60)).randomElement() ?? 0))
    
    
    static let list = (0...30).map { _ in Comment() }.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
    
    
}


extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}


extension Int {
    
    
    
    var short: String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)B"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)M"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)K"

        case 0...:
            return "\(self)"

        default:
            return "\(sign)\(self)"
        }
    }
    
}
