//
//  ViewController.swift
//  Tweet Monitor
//
//  Created by Luke Stringer on 30/03/2018.
//  Copyright © 2018 Luke Stringer. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: TWTRTimelineViewController {
	
	let screenName = "lukestringer90"
	let listSlug = "Travel"
	
	var tweetView: TWTRTweetView!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard TWTRTwitter.sharedInstance().sessionStore.session() != nil else {
			login()
			return
		}
		
		setupTimeline()

		
	}
	
	func login() {
		TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
			guard session != nil else {
				let alert = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
				self.show(alert, sender: nil)
				return
			}
			
			self.setupTimeline()
		})
	}
	
	func setupTimeline() {
		dataSource = FilteredListTimelineDataSource(listSlug: listSlug,
													listOwnerScreenName: screenName,
													searchStrings: ["Sheffield", "Rotherham"],
													apiClient: TWTRAPIClient())
		title = listSlug
	}

}
