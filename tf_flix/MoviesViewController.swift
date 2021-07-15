//
//  MoviesViewController.swift
//  tf_flix
//
//  Created by Harmony Scarlet on 7/7/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    @IBOutlet weak var tableView: UITableView!
    
    // declare and array of dictionaries
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        // API call to movies site, code copied from assignment page
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // Get array of movies and store in property to use elsewhere
                self.movies = dataDictionary["results"] as! [[String:Any]]
                // tell table view to update after API call results
                self.tableView.reloadData()
                print(dataDictionary)

            }
        }
        task.resume()
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // creates a generic cell
        // let cell = UITableViewCell()
        // create the reusable cell so that off screne cells can be reused
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = movies[indexPath.row]
        // cast title as String
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        // swift optionals is why we put ? or ! in
        // cell.textLabel!.text = "row: \(indexPath.row)"
        // cell.textLabel is for a generic cell
        // cell.textLabel!.text = title
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseURL + posterPath)!
        cell.posterView.af.setImage(withURL: posterUrl)
        return cell
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Loading up the details screen")
        // Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        // deselect row so that it is no longer highlighted when we return to screen
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
