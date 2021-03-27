//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Tirth Patel on 2018-07-31.
//  Copyright © 2018 Tirth Patel. All rights reserved.
//




// if you are able to see this comment that means i have left some work of launching the screen and making a clear button functionality in that cool retro claculator!!!

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var OuputLabel: UILabel!
    var btnSound: AVAudioPlayer!
    var runningNumber = "" // remember to initialize any variable you declare in swift you need to initialize it with some value for your best practice.
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty
    var leftValString  = ""
    var rightValString = ""
    var result = ""
    var didPressEqual = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let path  = Bundle.main.path (forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        OuputLabel.text = "0"
        do{
            try btnSound = AVAudioPlayer(contentsOf: soundURL) //try if the sound file is there or not
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    
    //now the sound got loaded into URL And how do we actually play it !!!!
    @IBAction func numberPressed(sender: UIButton){
        PlaySound()
        //number can be get by sender as its that button
        
        runningNumber += "\(sender.tag)"
        OuputLabel.text = runningNumber
    }
    
    //Handling every operation press event to make the perfomance
    
    @IBAction func OnDividePressed (sender : AnyObject){
        processOpertion(operation: .Divide)
        didPressEqual = false
    }
    @IBAction func OnMultiplyPressed (sender : AnyObject){
        processOpertion(operation: .Multiply)
        didPressEqual = false
    }
    @IBAction func OnAddPressed (sender : AnyObject){
        processOpertion(operation: .Add)
        didPressEqual = false
    }
    @IBAction func OnSubtractPressed (sender : AnyObject){
        processOpertion(operation: .Subtract)
        didPressEqual = false
    }
    @IBAction func OnEqualClicked(sender: AnyObject){
        processOpertion(operation: currentOperation)
        didPressEqual = true
    }
    
    
    func PlaySound (){
        
        if btnSound.isPlaying{
            btnSound.stop()
        }
        
        btnSound.play()
        
    }
    
    func processOpertion(operation: Operation){
        PlaySound()
        
        if currentOperation != Operation.Empty{
            // So a user selected an operator, but then selected another operator that is what this check is for.
            if runningNumber != ""{
                rightValString = runningNumber
                runningNumber = ""
        
                if currentOperation == Operation.Multiply{
                    result = "\(Double(leftValString)! * Double(rightValString)!)"
                }else if currentOperation == Operation.Divide{
                    result = "\(Double(leftValString)! / Double(rightValString)!)"
                }else if currentOperation == Operation.Add{
                    result = "\(Double(leftValString)! + Double(rightValString)!)"
                }else if currentOperation == Operation.Subtract{
                    result = "\(Double(leftValString)! - Double(rightValString)!)"
                }
                
                leftValString = result
                OuputLabel.text = result
            }
        } else{
            //this is the first time when the operator has been pressed
            leftValString = runningNumber
            runningNumber = ""
        }
        currentOperation = operation
        if (didPressEqual) {
            currentOperation = .Empty
        }
        
    }
    
}

extension UITextField {
    private func actionHandleBlock(action:(()->())? = nil) {
        struct __ {
            var closure: (() -> Void)?
            typealias EmptyCallback = ()->()
            static var action: [EmptyCallback] = []
        }
        if action != nil {
           // _.action![(_.action?.count)!] = action!
            self.tag = (__.action.count)
            __.action.append(action!)
        } else {
            let exe = __.action[self.tag]
            exe()
        }
    }

    @objc private func triggerActionHandleBlock() {
        self.actionHandleBlock()
    }

    func addAction(forControlEvents control: UIControl.Event, ForAction action: @escaping () -> Void) {
        self.actionHandleBlock(action: action)
        self.addTarget(self, action: #selector(triggerActionHandleBlock), for: control)
    }
}



