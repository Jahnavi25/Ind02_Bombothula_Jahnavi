//
//  ViewController.swift
//  Ind02_Bombothula_Jahnavi
//
//  Created by Jahnavi Bombothula on 3/23/24.
//

import UIKit

class ViewController: UIViewController {

    // Image views for each cell in the puzzle.
    @IBOutlet weak var cell00: UIImageView!
    @IBOutlet weak var cell01: UIImageView!
    @IBOutlet weak var cell02: UIImageView!
    @IBOutlet weak var cell03: UIImageView!
    @IBOutlet weak var cell10: UIImageView!
    @IBOutlet weak var cell11: UIImageView!
    @IBOutlet weak var cell12: UIImageView!
    @IBOutlet weak var cell13: UIImageView!
    @IBOutlet weak var cell20: UIImageView!
    @IBOutlet weak var cell21: UIImageView!
    @IBOutlet weak var cell22: UIImageView!
    @IBOutlet weak var cell23: UIImageView!
    @IBOutlet weak var cell30: UIImageView!
    @IBOutlet weak var cell31: UIImageView!
    @IBOutlet weak var cell32: UIImageView!
    @IBOutlet weak var cell33: UIImageView!
    @IBOutlet weak var cell40: UIImageView!
    @IBOutlet weak var cell41: UIImageView!
    @IBOutlet weak var cell42: UIImageView!
    @IBOutlet weak var cell43: UIImageView!
    
    // Full image view shows the complete picture for reference.
    @IBOutlet weak var fullImage: UIImageView!
    
    // Buttons for user interaction to shuffle and reveal the puzzle answer.
    @IBOutlet weak var shuffleClicked: UIButton!
    @IBOutlet weak var showHideAnswerClicked: UIButton!
    
    
    // Defines the number of rows and columns in the puzzle.
    let rows = 5
    let cols = 4
    
    // Tracks the current empty position in the puzzle grid.
    var empty: (row: Int, col: Int) = (4, 3)
    
    
    // 2D array of image views representing the current state of the puzzle.
    lazy var images =  [[cell00,cell01,cell02,cell03],
                        [cell10,cell11,cell12,cell13],
                        [cell20,cell21,cell22,cell23],
                        [cell30,cell31,cell32,cell33],
                        [cell40,cell41,cell42,cell43]]
    
    
    // 2D array mapping each cell to its corresponding image file.
    var imageFiles =
        [["cell00.png","cell01.png","cell02.png","cell03.png"],
        ["cell10.png","cell11.png", "cell12.png","cell13.png"],
        ["cell20.png","cell21.png","cell22.png","cell23.png"],
        ["cell30.png","cell31.png","cell32.png","cell33.png"],
        ["cell40.png","cell41.png","cell42.png","cell43.png"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        puzzleState()
    }
    
    // Handles tap gestures on puzzle cells to attempt a move.
    @IBAction func tapGestureHandle(_ sender: UITapGestureRecognizer) {
        //print("clicked Once")
        let new_Position = ViewPosition(imageView: sender.view!)!
        if (empty.0 == new_Position.0 && (empty.1 == new_Position.1+1 || empty.1 == new_Position.1-1)||empty.1 == new_Position.1 && (empty.0 == new_Position.0+1 || empty.0 == new_Position.0-1)){
            swapImages(imgPos: new_Position)
            if checkSolved() == true {
                shuffleClicked.setTitle("Solved! Shuffle Again?", for: .normal)
//                shuffleClicked.backgroundColor = .systemPink
            }
        }
    }

    // Initiates the shuffle process of the puzzle pieces.
    @IBAction func shuffleTapped(_ sender: Any) {
        if shuffleClicked.titleLabel?.text == "Shuffle" {
            shuffle()
            shuffleClicked.isEnabled = false
            //print("Here")
        } else {
            shuffleClicked.setTitle("Shuffle", for: .normal)
//            shuffleClicked.backgroundColor = .systemRed
        }
    }
    
    // Switch between showing the solved puzzle and the current game state.
    @IBAction func showAnswerTapped(_ sender: Any) {
        if showHideAnswerClicked.titleLabel?.text == "Show Answer" {
            solvedState()
            showHideAnswerClicked.setTitle("Hide Answer", for: .normal)
        } else {
            showHideAnswerClicked.setTitle("Show Answer", for: .normal)
            puzzleState()
        }
    }
    
    // Checks if the puzzle has been solved correctly.
    func checkSolved() -> Bool{
        for x in 0...rows-1{
            for y in 0...cols-1{
                if imageFiles[x][y] != "cell\(x)\(y).png" {
                    return false
                }
            }
        }
        shuffleClicked.isEnabled = true
        return true
    }
    
    // Displays the solution to the puzzle.
    func solvedState(){
        for x in 0...rows-1{
            for y in 0...cols-1{
                let img = UIImage(named: "cell\(x)\(y).png")
                images[x][y]?.image = img
            }
        }
    }
    
    // A function that sets the ImageViews to the present position of the images.
    func puzzleState(){
        for x in 0...rows-1{
            for y in 0...cols-1{
                let img = UIImage(named: imageFiles[x][y])
                images[x][y]?.image = img
            }
        }
    }
    
    //This returns the position of a View in the 2-D array
    func ViewPosition(imageView: UIView) -> (Int, Int)? {
        for x in 0...rows-1{
            for y in 0...cols-1{
                if imageView == images[x][y]{
                    return (x, y)
                }
            }
        }
        return nil
    }
    
    // A custom function that handles the shuffle logic using the swapImages function.
    func shuffle() {
        for _ in stride(from: 200, to: 0, by: -1) {
            let nums = [-1,0,1]
            let direction = (nums.randomElement()!, nums.randomElement()!)
            let new_Position: (Int, Int) = (empty.0 + direction.0, empty.1 + direction.1)
            if 0 <= new_Position.0 && new_Position.0 < rows && 0 <= new_Position.1 && new_Position.1 < cols {
                swapImages(imgPos: new_Position)
                empty = new_Position
            }
        }
    }
    
    // This function swaps the images of the empty position with the image of a view/cell tapped
    func swapImages(imgPos: (Int, Int)) {
        let tappedImg = images[imgPos.0][imgPos.1]?.image
        let tappedImgFile = imageFiles[imgPos.0][imgPos.1]
        imageFiles[imgPos.0][imgPos.1] = imageFiles[empty.0][empty.1]
        images[imgPos.0][imgPos.1]?.image = images[empty.0][empty.1]?.image
        imageFiles[empty.0][empty.1] = tappedImgFile
        images[empty.0][empty.1]?.image = tappedImg
        empty = imgPos
    }
}
