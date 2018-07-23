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

    var movies = [Movie]()
    var searches = [Search]()
    var currentPage = 1
    var page = 0
    var query = ""
    var isRecently = false

    let movieHelper = MovieHelper()
    let coreData = CoreDataHelper()


    var retryLimiter = 0
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

    @objc func search() {
        self.currentPage = 1
        self.movies.removeAll()
        self.retryLimiter = 0
        self.recentlyTable.isHidden = true

        if !((searchTF.text?.isEmpty)!) || self.isRecently {
            if(self.searchTF.text != self.query) {
                self.resultTable.isHidden = true
                self.searchBtn.isHidden = true
                self.indicator.isHidden = false
                self.indicator.startAnimating()
                if !self.isRecently { self.query = searchTF.text! }
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
        let search = Search()
        search.title = self.query
        let isSaved = coreData.pushToCoreDataStack(search: search)
        if !isSaved{
            ViewHelper.showToastMessage(message: "couldn't save the search query!")
        }
        self.currentPage += 1
        self.isRecently = false
    }

    func failedToGetMovie(error: String) {
        if retryLimiter < 5 {
            self.indicator.isHidden = true
            self.searchBtn.isHidden = false
            movieHelper.getMovies(page: self.currentPage, query: self.query)
            retryLimiter += 1
            if retryLimiter == 4{
                ViewHelper.showToastMessage(message: error)
            }
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == resultTable{
            return movies.count
        }else{
            return searches.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == resultTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: Values.MOVIE_CELL, for: indexPath) as! MovieTVC
            let movie = movies[indexPath.row]
            cell.movieTitleLbl.text = movie.name
            cell.movieReleaseDateLbl.text = "🕒 " + movie.date
            cell.movieInfoLbl.text = movie.info
            if movie.info.isEmpty {
                cell.arrowImg.isHidden = true
            }
            cell.movieImg.pin_setImage(from: URL(string: (Values.PIC_URL + movie.poster))!)
            cell.row = indexPath

            if indexPath.row == movies.count - 1 {
                if currentPage < page - 1 {
                    movieHelper.getMovies(page: currentPage, query: self.query)
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Values.SEARCH_CELL, for: indexPath) as! SearchTVC
            let search = searches[indexPath.row]
            cell.deleteBtn.isHidden = false
            cell.searchTitleLbl.text = search.title
            cell.searchEntity = search
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == resultTable{
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
            if expandedCell != nil {
                let cell = tableView.cellForRow(at: expandedCell!) as! MovieTVC
                cell.movieInfoLbl.isHidden = true
                cell.arrowImg.image = #imageLiteral(resourceName: "down")
                expandedCell = nil
            } else if expandedCell == indexPath {
                expandedCell = nil
            } else {
                let cell = tableView.cellForRow(at: indexPath) as! MovieTVC
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
            if self.query != searches[indexPath.row].title{
                self.query = searches[indexPath.row].title
                self.isRecently = true
                self.search()
            }
        }

    }

    @IBAction func focusOnTF(_ sender: Any) {
        let data = coreData.fetchFromCoreData()
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
