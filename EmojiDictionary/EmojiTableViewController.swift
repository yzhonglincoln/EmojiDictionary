//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Soft Dev Student on 5/8/19.
//  Copyright © 2019 Alice Zhong. All rights reserved.
//

import UIKit

class EmojiTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // assign row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        // load emojis
        emojis.append(contentsOf: Emoji.loadFromFile())
    }
    
    // refresh data
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // allow table view to be editted
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    // table view cells not take up the entire width of the table view
    var cellLayoutMarginsFollowReadableWidth = true
    
    // array of emojis
    var emojis: [Emoji] = []

    // return number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // return number of rows accounting to number of sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return emojis.count
        } else {
            return 0
        }
    }
    // return the cell in the row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
        // fetch model object to display
        let emoji = emojis[indexPath.row]
        // configure cell
        cell.update(with: emoji)
        cell.showsReorderControl = true
        // return cell
        return cell
    }
    
    // let cell be able to be moved around
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = emojis.remove(at: sourceIndexPath.row)
        emojis.insert(movedEmoji, at: destinationIndexPath.row)
        Emoji.saveToFile(emojis: emojis)
        tableView.reloadData()
    }
    
    // change the editing style to delete
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // edit the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emojis.remove(at: indexPath.row)
            Emoji.saveToFile(emojis: emojis)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // pass the Emoji object to static table view when a cell is tapped
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEmoji" {
            let indexPath = tableView.indexPathForSelectedRow!
            let emoji = emojis[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let addEditEmojiTableViewController = navController.topViewController as! AddEditEmojiTableViewController
            
            addEditEmojiTableViewController.emoji = emoji
        }
    }
    
    // when save to emoji table view
    @IBAction func unwindToEmojiTableView(unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "saveUnwind" else { return }
        let sourceViewController = unwindSegue.source as! AddEditEmojiTableViewController
        
        if let emoji = sourceViewController.emoji {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                emojis[selectedIndexPath.row] = emoji
                Emoji.saveToFile(emojis: emojis)
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: emojis.count, section: 0)
                emojis.append(emoji)
                Emoji.saveToFile(emojis: emojis)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
 
    // MARK: - Table view data source
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
