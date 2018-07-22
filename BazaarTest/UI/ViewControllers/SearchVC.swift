//
//  SearchVC.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/28 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import PINRemoteImage


class SearchVC: UIViewController, MovieDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var resultTable: UITableView!

    var movies = [Movie]()
    var currentPage = 1
    var page = 0
    var query = ""

    let movieHelper = MovieHelper()

    var retryLimiter = 0
    var expandedCell: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultTable.delegate = self
        self.resultTable.dataSource = self
        self.resultTable.isHidden = true

        self.indicator.isHidden = true
        self.searchBtn.addTarget(self, action: #selector(self.search), for: .touchUpInside)
        // Do any additional setup after loading the view.
        movieHelper.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func search() {
        self.currentPage = 1
        self.movies.removeAll()
        self.retryLimiter = 0
        self.resultTable.isHidden = true

        if !((searchTF.text?.isEmpty)!) {
            if(self.searchTF.text != self.query) {
                self.searchBtn.isHidden = true
                self.indicator.isHidden = false
                self.indicator.startAnimating()
                self.query = searchTF.text!
                movieHelper.getMovies(page: currentPage, query: self.query)
            }
        } else {
            ViewHelper.showToastMessage(message: "I can't search for nothing!")
        }

    }

    func getMovieSuccessfuly(lstMovies: [Movie], page: Int) {
        self.page = page
        for movie in lstMovies {
            self.movies.append(movie)
        }
        self.indicator.isHidden = true
        self.searchBtn.isHidden = false
        self.resultTable.isHidden = false
        self.resultTable.reloadData()
        self.currentPage += 1
    }

    func failedToGetMovie(error: String) {
        if retryLimiter < 5 {
            ViewHelper.showToastMessage(message: "error!")
            self.indicator.isHidden = true
            self.searchBtn.isHidden = false
            movieHelper.getMovies(page: self.currentPage, query: self.query)
            retryLimiter += 1
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTVC
        let movie = movies[indexPath.row]
        cell.movieTitleLbl.text = movie.name
        cell.movieReleaseDateLbl.text = "🕒 " + movie.date
        if movie.info.isEmpty {
            cell.movieInfoLbl.text = "No info!"
        } else {
            cell.movieInfoLbl.text = movie.info
        }
        cell.movieImg.pin_setImage(from: URL(string: (Values.PIC_URL + movie.poster))!)
        cell.row = indexPath

        if indexPath.row == movies.count - 1 {
            if currentPage < page - 1 {
                movieHelper.getMovies(page: currentPage, query: self.query)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == expandedCell {
            return 200
        }
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if expandedCell != nil {
            let cell = tableView.cellForRow(at: expandedCell!) as! MovieTVC
            cell.movieInfoLbl.isHidden = true
            expandedCell = nil
        } else if expandedCell == indexPath {
            expandedCell = nil
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! MovieTVC
            cell.movieInfoLbl.isHidden = !cell.movieInfoLbl.isHidden
            expandedCell = indexPath
        }

        tableView.beginUpdates()
        tableView.endUpdates()

        if expandedCell != nil {
            // This ensures, that the cell is fully visible once expanded
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }

    }

    @IBAction func focusOnTF(_ sender: Any) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
