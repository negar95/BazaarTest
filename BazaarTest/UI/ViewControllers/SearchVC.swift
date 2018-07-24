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
    @IBOutlet weak var recentlyTable: UITableView!

    ///array of result movies
    var movies = [Movie]()
    ///array of recently searches
    var searches = [Search]()
    ///current page of search result
    var currentPage = 1
    ///number of result pages
    var page = 0
    ///search query
    var query = ""
    ///it says if the search query is from recently searches
    var isRecently = false

    let movieHelper = MovieHelper()
    let coreData = CoreDataHelper()

    ///limit the server request retry
    var retryLimiter = 0
    ///the cell that expands
    var expandedCell: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        movieHelper.delegate = self

        self.resultTable.delegate = self
        self.resultTable.dataSource = self

        self.recentlyTable.delegate = self
        self.recentlyTable.dataSource = self

        self.initViews()
        // Do any additional setup after loading the view.
    }

    ///initialize the views
    func initViews() {
        self.resultTable.isHidden = true

        self.recentlyTable.isHidden = true

        self.recentlyTable.layer.borderWidth = 1
        self.recentlyTable.layer.masksToBounds = true
        self.recentlyTable.layer.cornerRadius = 10

        self.indicator.isHidden = true
        self.searchBtn.addTarget(self, action: #selector(self.search), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    ///do some checks, get the query from textfield or recentlies and request for search
    @objc func search() {
        self.currentPage = 1
        self.movies.removeAll()
        self.retryLimiter = 0
        self.recentlyTable.isHidden = true

        if !((searchTF.text?.isEmpty)!) || self.isRecently {
            //if user doesn't change the query we don't need to request again
            if(self.searchTF.text != self.query) {
                self.resultTable.isHidden = true
                self.searchBtn.isHidden = true
                self.indicator.isHidden = false
                self.indicator.startAnimating()
                //check if query is from recentlies
                if !self.isRecently { self.query = searchTF.text! }
                movieHelper.getMovies(page: currentPage, query: self.query)
            }
        } else {
            ViewHelper.showToastMessage(message: "I can't search for nothing!")
        }

    }

    ///The movie delegate method for success
    func getMovieSuccessfuly(lstMovies: [Movie], page: Int) {
        self.page = page
        for movie in lstMovies {
            self.movies.append(movie)
        }
        self.indicator.isHidden = true
        self.searchBtn.isHidden = false
        self.resultTable.isHidden = false
        self.resultTable.reloadData()

        let search = Search()
        search.title = self.query
        //save the search in coredata for recentlies
        let isSaved = coreData.pushToCoreDataStack(search: search)
        //show error if the save function wasn't successfull
        if !isSaved{
            ViewHelper.showToastMessage(message: "couldn't save the search query!")
        }
        self.currentPage += 1
        self.isRecently = false
    }

    ///The movie delegate method for error
    func failedToGetMovie(error: String) {
        //if an error occured the request will be send 5 times
        if retryLimiter < 5 {
            self.indicator.isHidden = true
            self.searchBtn.isHidden = false
            movieHelper.getMovies(page: self.currentPage, query: self.query)
            retryLimiter += 1
            //at last retry the error will be shown
            if retryLimiter == 4{
                ViewHelper.showToastMessage(message: error)
            }
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //for each table number of rows is the count of array
        if tableView == resultTable{
            return movies.count
        }else{
            return searches.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == resultTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: Values.MOVIE_CELL, for: indexPath) as! MovieTVC
            //gets the movie for each indexPath
            let movie = movies[indexPath.row]
            //sets movie variables
            cell.movieTitleLbl.text = movie.name
            cell.movieReleaseDateLbl.text = "🕒 " + movie.date
            cell.movieInfoLbl.text = movie.info
            //sets a proper text for empty info case
            if movie.info.isEmpty {
                cell.arrowImg.isHidden = true
            }
            //loads the image from url
            cell.movieImg.pin_setImage(from: URL(string: (Values.PIC_URL + movie.poster))!)
            cell.row = indexPath

            //if user reach the end of array in table it will request for the next page again
            if indexPath.row == movies.count - 1 {
                if currentPage < page - 1 {
                    movieHelper.getMovies(page: currentPage, query: self.query)
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Values.SEARCH_CELL, for: indexPath) as! SearchTVC
            //gets the search for each indexPath
            let search = searches[indexPath.row]
            //sets search variables
            cell.deleteBtn.isHidden = false
            cell.searchTitleLbl.text = search.title
            cell.searchEntity = search
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if tableView == resultTable{
            //expand cell to show more info
            if indexPath == expandedCell {
                return 200
            }
            return 100
        }else{
            return 30
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        self.recentlyTable.isHidden = true

        if tableView == resultTable{
            //if any cell include the one that selected was expanded, contract it
            if expandedCell != nil {
                let cell = tableView.cellForRow(at: expandedCell!) as! MovieTVC
                cell.movieInfoLbl.isHidden = true
                cell.arrowImg.image = #imageLiteral(resourceName: "down")
                expandedCell = nil
            } else {
                let cell = tableView.cellForRow(at: indexPath) as! MovieTVC
                //in cell for row set arrowImg.isHidden to true if movie info is empty
                //if the movie don't have info did select do nothing
                if !cell.arrowImg.isHidden{
                    cell.movieInfoLbl.isHidden = !cell.movieInfoLbl.isHidden
                    if cell.movieInfoLbl.isHidden{
                        cell.arrowImg.image = #imageLiteral(resourceName: "down")
                    }else{
                        cell.arrowImg.image = #imageLiteral(resourceName: "up")
                    }
                    expandedCell = indexPath
                }
            }

            tableView.beginUpdates()
            tableView.endUpdates()

            if expandedCell != nil {
                // This ensures, that the cell is fully visible once expanded
                tableView.scrollToRow(at: indexPath, at: .none, animated: true)
            }
        }else{
            //check to not repeat request
            if self.query != searches[indexPath.row].title{
                self.query = searches[indexPath.row].title
                //set flag to true
                self.isRecently = true
                self.search()
            }
        }

    }

    //when tap on textfield recentlies should be shown
    @IBAction func focusOnTF(_ sender: Any) {
        let data = coreData.fetchFromCoreData()
        //check if no recently search was found
        if data != nil{
            self.searches = data!
            recentlyTable.isHidden = false
            recentlyTable.reloadData()
        }
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
