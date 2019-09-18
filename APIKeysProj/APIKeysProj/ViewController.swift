//
//  ViewController.swift
//  APIKeysProj
//
//  Created by Kevin Natera on 9/9/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableOutlet: UITableView!
    
    var songs = [SongWrapper]() {
        didSet {
            tableOutlet.reloadData()
        }
    }
    
    var searchString: String? = nil {
        didSet {
            tableOutlet.reloadData()
        }
    }
    
    var songSearchResults: [SongWrapper] {
        get {
            guard let _ = searchString else {
                return songs
            }
            guard searchString != "" else {
                return songs
            }
            return songs
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableOutlet.dequeueReusableCell(withIdentifier: "song")
        let song = songSearchResults[indexPath.row].message.body.track_list[indexPath.row].track
        
        cell?.textLabel?.text = song.track_name
        cell?.detailTextLabel?.text = song.artist_name
        
        return cell!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchBar.text
        loadData(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchString = searchBar.text
        loadData(query: searchString)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else { fatalError() }
        //detailVC.lyrics = non-existent lyrics
    }
    
    private func loadData(query: String?) {
        SongWrapper.getSongs(userInput: query) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let songs):
                    self.songs = songs
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableOutlet.delegate = self
        tableOutlet.dataSource = self
    }

}

