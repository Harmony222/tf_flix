//
//  MovieDetailsViewController.swift
//  tf_flix
//
//  Created by Harmony Scarlet on 7/14/21.
//

import UIKit
import AlamofireImage
class MovieDetailsViewController: UIViewController {
    
    var movie: [String:Any]!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseURL + posterPath)!
        posterView.af.setImage(withURL: posterUrl)
        
        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)!
        backdropView.af.setImage(withURL: backdropUrl)
        
        // For allowing text to scroll in the synopsis label
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: synopsisLabel.bottomAnchor).isActive = true
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPoster(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        posterView.isUserInteractionEnabled = true
        posterView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func didTapPoster(_ sender: UITapGestureRecognizer) {
        print("tapped")
        performSegue(withIdentifier: "trailerSegue", sender: nil)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let movieTrailerViewController = segue.destination as! MovieTrailerViewController
        // Pass the selected object to the new view controller.
        movieTrailerViewController.movie = movie
    }
    

}
