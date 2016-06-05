//
//  DictionaryViewController
//  Dictionary
//
//  Created by Will Hains on 2014-11-24.
//  Copyright (c) 2014 Will Hains. All rights reserved.
//

import UIKit

class DictionaryViewController: UIViewController
{
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
}

// MARK:- Search Bar delegate
extension DictionaryViewController: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(searchBar: UISearchBar)
	{
		// Search the dictionary
		if let searchText = searchBar.text
		{
			let dictionaryVC = UIReferenceLibraryViewController(term: searchText)
			presentViewController(dictionaryVC, animated: true)
			{
				if UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(searchText)
				{
					// Clear the search bar
					self.searchBar.text = nil
				}
			}
		}
	}
}

// MARK:- Giant search bar
extension DictionaryViewController
{
	override func viewDidAppear(animated: Bool)
	{
		// Increase size of font and height of search bar
		forEachSubview(ofView: self.searchBar, thatIsA: UITextField.self)
		{
			textField in
			textField.font = .systemFontOfSize(24)
			textField.bounds.size.height = 88
			textField.autocapitalizationType = .None
		}
		
		// Show the keyboard on launch, so you can start typing right away
		self.searchBar.becomeFirstResponder()
	}
	
	// Rummage through the subviews of the given UIView
	func forEachSubview<V: UIView>(ofView view: UIView, thatIsA type: V.Type, actUponSubview: V -> Void)
	{
		for subview in view.subviews
		{
			if let subview = subview as? V { actUponSubview(subview) }
			forEachSubview(ofView: subview, thatIsA: type, actUponSubview: actUponSubview)
		}
	}
}
