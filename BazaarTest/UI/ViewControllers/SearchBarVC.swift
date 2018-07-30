//
//  SearchBarVC.swift
//  BazaarTest
//
//  Created by negar on 97/Mordad/08 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class SearchBarVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MovieDelegate {


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

    var isRecentlyTable = false
    var retryLimiter = 0
    var expandedCell: IndexPath?


    let movieHelper = MovieHelper()
    let coreData = CoreDataHelper()

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieHelper.delegate = self
        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getMovieSuccessfuly(lstMovies: [Movie], page: Int) {
        self.page = page
        for movie in lstMovies {
            self.movies.append(movie)
        }

        self.isRecently = false
        self.table.reloadData()
        
        let search = Search()
        search.title = self.query
        //save the search in coredata for recentlies
        let isSaved = coreData.pushToCoreDataStack(search: search)
        //show error if the save function wasn't successfull
        if !isSaved{
            ViewHelper.showToastMessage(message: "couldn't save the search query!")
        }
        self.currentPage += 1

    }

    ///The movie delegate method for error
    func failedToGetMovie(error: String) {
        //if an error occured the request will be send 5 times
        if retryLimiter < 5 {
            movieHelper.getMovies(page: self.currentPage, query: self.query)
            retryLimiter += 1
            //at last retry the error will be shown
            if retryLimiter == 4{
                ViewHelper.showToastMessage(message: error)
            }
        }

    }

    func initViews(){
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRecentlyTable{
            return searches.count
        }else{
            return movies.count
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isRecentlyTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: Values.SEARCH_CELL, for: indexPath) as! SearchTVC
            //gets the search for each indexPath
            let search = searches[indexPath.row]
            //sets search variables
            cell.deleteBtn.isHidden = false
            cell.searchTitleLbl.text = search.title
            cell.searchEntity = search
            return cell
        }else{
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
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isRecentlyTable{
            //expand cell to show more info
            return 30
        }else{
            if indexPath == expandedCell {
                return 200
            }
            return 100

        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isRecentlyTable{
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
                movieHelper.getMovies(page: currentPage, query: self.query)
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.currentPage = 1
        self.movies.removeAll()
        self.retryLimiter = 0

        if !((searchBar.text?.isEmpty)!){
            //if user doesn't change the query we don't need to request again
            if(self.searchBar.text != self.query) {
                self.query = searchBar.text!
                movieHelper.getMovies(page: currentPage, query: self.query)
            }
        } else {
            ViewHelper.showToastMessage(message: "I can't search for nothing!")
        }
        self.isRecentlyTable = false

    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let data = coreData.fetchFromCoreData()
        //check if no recently search was found
        if data != nil{
            self.isRecentlyTable = true
            self.searches = data!
            table.reloadData()
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
