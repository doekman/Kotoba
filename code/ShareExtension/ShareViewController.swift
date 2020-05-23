//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Will Hains on 2020-05-05.
//  Copyright © 2020 Will Hains. All rights reserved.
//

import UIKit
import Social
import CoreServices

class ShareViewController: UIViewController
{
	@IBOutlet weak var wordLabel: UILabel!
	
	var contentText: String = ""

	required init?(coder: NSCoder)
	{
		super.init(coder: coder)
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
		let itemProvider = extensionItem.attachments?.first!
        let propertyList = String(kUTTypeText)
		if itemProvider?.hasItemConformingToTypeIdentifier(propertyList) ?? false
		{
			itemProvider?.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler:
			{
				(item, error) -> Void in
				guard let text = item as? String else { return }
				self.contentText = text
				self.wordLabel.text = text
            })
        }
		else
		{
            print("error")
        }
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		debugLog("_____ tableView")
		debugLog("iCloud=\(NSUbiquitousKeyValueStore.iCloudEnabledInSettings)")
		debugLog("wordListStore.data=\(wordListStore.data.asText())")
		
		// Skip straight to definition if there is only one word
		initiateSearch(forWord: Word(text: contentText))
	}
	
	func cancelShare()
	{
		extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
	}
	
	@IBAction func didTapCancel(_ sender: UIBarButtonItem)
	{
		cancelShare()
	}
}

// MARK:- Kotoba and Dictionary Integration
extension ShareViewController
{
	func initiateSearch(forWord word: Word)
	{
		let hasDefinition = UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word.text)
		debugLog("hasDefinition = \(hasDefinition)")
		let dictionaryViewController = DictionaryViewController(term: word.text)
		self.present(dictionaryViewController, animated: true)
		{
			dictionaryViewController.onDismiss =
			{
				if hasDefinition
				{
					var words = wordListStore.data
					words.add(word: word)
					
					self.cancelShare()
				}
			}
		}
	}
}
