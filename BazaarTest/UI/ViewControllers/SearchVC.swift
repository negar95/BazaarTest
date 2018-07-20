//
//  SearchVC.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/28 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import PINRemoteImage


class SearchVC: UIViewController, MovieDelegate, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var resultTable: UITableView!

    var movies = [Movie]()
    var currentPage = 1
    var page = 0
    var query = ""

    let movieHelper = MovieHelper()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movieHelper.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func search(){
        if !((searchTF.text?.isEmpty)!){
            self.query = searchTF.text!
            resultTable.reloadData()
        }else{
            ViewHelper.showToastMessage(message: "I can't search nothing!")
        }
        resultTable.reloadData()
    }

    func getMovieSuccessfuly(lstMovies: [Movie], page: Int) {
        self.page = page
        for movie in lstMovies{
            self.movies.append(movie)
        }
        self.resultTable.reloadData()
        self.page += 1
    }

    func failedToGetMovie(error: String) {
        ViewHelper.showToastMessage(message: "Some error occured!")
        movieHelper.getMovies(page: self.page, query: self.query)

    }

    func getMovies() -> [Movie]{
        return movies
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTVC
        let movie = movies[indexPath.row]
        cell.movieInfoLbl.text = movie.info
        cell.movieReleaseDateLbl.text = "🕒 "+movie.date
        cell.movieInfoLbl.text = movie.info
        cell.movieImg.pin_setImage(from: URL(string: (Values.PIC_URL + movie.poster))!)

        if indexPath.row == movies.count - 1{
            if currentPage < page{
                movieHelper.getMovies(page: currentPage, query: self.query)
            }
        }
        return cell
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
