//
//  Podcast.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import Foundation



struct Podcast: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let description: String
    let duration: TimeInterval
    
    static let list = [
        Podcast(title: "Jon Prosser RUINED WWDC...", date: Date.string("09-06-2021"), description: "Jon Prosser and Sam Kohl discuss WWDC 2021, including the non-existent M1X MacBook Pros, iOS and iPadOS 15, watchOS 8 and macOS 12 Monterey. These are our thoughts......", duration: 1 * 60 * 60 + 26 * 60 + 21),
        
        Podcast(title: "The iPad is F****d", date: Date.string("01-06-2021"), description: "Jon Prosser and Sam Kohl are concerned about the state of the iPad ahead of WWDC next week. Plus, an intense argument about the way they each buy new products...", duration: 1 * 60 * 60 + 54 * 60 + 2),
        
        Podcast(title: "We got our new iMacs and we have THOUGHTS...", date: Date.string("25-05-2021"), description: "Genius Bar", duration: 1 * 60 * 60 + 24 * 60 + 5),
        
        Podcast(title: "Exclusive: Apple's SECRET PLAN for AirPods", date: Date.string("18-05-2021"), description: "Apple just announced lossless audio, but no AirPods support it...yet. Plus, Jon Prosser and Sam Kohl do a deep dive on Apple's ongoing court battle and more on this appointment at the Genius Bar.", duration: 1 * 60 * 60 + 5 * 60 + 19),
        
        Podcast(title: "The RETURN of the MacBook...", date: Date.string("12-05-2021"), description: "Jon Prosser and Sam Kohl react to a recent video about tech YouTubers and the state of YouTube as a whole...plus, more thoughts on the all new M1 iMac and a discussion about the return of the MacBook, MacBook.", duration: 1 * 60 * 60 + 28 * 60 + 49),
        
        Podcast(title: "Sam WRECKED His Tesla...", date: Date.string("04-05-2021"), description: "Sam's week started off with quite the bang (he crashed his car)...and ended with some first impressions of AirTag. And Jon...well he has a myriad of interesting stories to share on this week's episode......", duration: 1 * 60 * 60 + 16 * 60 + 8),
        
        Podcast(title: "We changed our minds about the iMac...", date: Date.string("26-04-2021"), description: "Okay, okay... it's been about a week and we have slowly started to change our minds about how much we hate the new iMac redesign. We talk about that and more in this week's episode of Genius Bar!", duration: 1 * 60 * 60 + 11 * 60 + 55),
        
        Podcast(title: "This is NOT the iMac we wanted!", date: Date.string("22-04-2021"), description: "This week, Jon and Sam record just a few hours after the Apple April Event wraps up to give their full reaction and rundown of Apple's 'loaded' product drop!", duration: 1 * 60 * 60 + 4 * 60 + 21),
        
        Podcast(title: "BONUS EPISODE: The Apple April Event is official! Never doubt The Good Good.", date: Date.string("14-04-2021"), description: "We're back! Already, for our very first bonus episode! We are too excited. The Apple Event is official, Siri leaked it, and invites are now out! Here's what we think...", duration: 36 * 60 + 13)
    ]
}
