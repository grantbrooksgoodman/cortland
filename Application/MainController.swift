//
//  MainController.swift
//  Cortland
//
//  Created by Grant Brooks Goodman on 20/05/2021.
//  Copyright © 2013-2021 NEOTechnica Corporation. All rights reserved.
//

/* First-party Frameworks */
import MessageUI
import UIKit

/* Third-party Frameworks */
import PKHUD

class MainController: UIViewController, MFMailComposeViewControllerDelegate {
    
    //==================================================//
    
    /* MARK: - Interface Builder UI Elements */
    
    //UIButtons
    @IBOutlet weak var codeNameButton:     UIButton!
    @IBOutlet weak var informationButton:  UIButton!
    @IBOutlet weak var sendFeedbackButton: UIButton!
    @IBOutlet weak var subtitleButton:     UIButton!
    
    //UILabels
    @IBOutlet weak var bundleVersionLabel:     UILabel!
    @IBOutlet weak var projectIdentifierLabel: UILabel!
    @IBOutlet weak var skuLabel:               UILabel!
    
    //UIViews
    @IBOutlet weak var extraneousInformationView: UIView!
    @IBOutlet weak var preReleaseInformationView: UIView!
    
    //Other Elements
    @IBOutlet weak var collectionView: UICollectionView!
    
    //==================================================//
    
    /* MARK: - Class-level Variable Declarations */
    
    //Overridden Variables
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    //Other Declarations
    var buildInstance: Build!
    var timers: [CLTimer]!
    
    //==================================================//
    
    /* MARK: - Initializer Function */
    
    func initializeController() {
        /* Be sure to change the values below.
         *      The build number string when archiving.
         *      The code name of the application.
         *      The editor header file values.
         *      The first digit in the formatted version number.
         *      The value of the pre-release application boolean.
         *      The value of the prefers status bar boolean. */
        
        lastInitializedController = self
        buildInstance = Build(self)
    }
    
    //==================================================//
    
    /* MARK: - Overridden Functions */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeController()
        
        view.setBackground(withImageNamed: "Background Image")
        
        let randomSecondValue = Int().random(min: 15, max: 60)
        let randomDate = currentCalendar.date(byAdding: .second, value: randomSecondValue, to: Date())!
        
        timers = [CLTimer(title: "Test timer", alarmDate: randomDate)]
        
        navigationController?.navigationBar.backgroundColor = UIColor(hex: 0x242525)
        navigationController?.navigationBar.barTintColor = UIColor(hex: 0x242525)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21), NSAttributedString.Key.foregroundColor : UIColor(hex: 0xFF962C)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if informationDictionary["subtitleExpiryString"] == "Evaluation period ended." && preReleaseApplication {
            view.addBlur(withActivityIndicator: false, withStyle: .light, withTag: 1, alpha: 1)
            view.isUserInteractionEnabled = false
        }
        
        currentFile = #file
        buildInfoController?.view.isHidden = true
    }
    
    //==================================================//
    
    /* MARK: - Interface Builder Actions */
    
    @IBAction func codeNameButton(_ sender: AnyObject) {
        buildInstance.codeNameButtonAction()
    }
    
    @IBAction func informationButton(_ sender: AnyObject) {
        buildInstance.displayBuildInformation()
    }
    
    @IBAction func sendFeedbackButton(_ sender: Any) {
        AlertKit().feedbackController(withFileName: #file)
    }
    
    @IBAction func subtitleButton(_ sender: Any) {
        buildInstance.subtitleButtonAction(withButton: sender as! UIButton)
    }
    
    //==================================================//
    
    /* MARK: - Other Functions */
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        buildInstance.handleMailComposition(withController: controller, withResult: result, withError: error)
    }
    
    func randomColor() -> UIColor
    {
        let colors: [UIColor] = [UIColor(hex: 0x55EFC4), UIColor(hex: 0x74B9FF), UIColor(hex: 0xE17055), UIColor(hex: 0xFD79A8)]
        
        return colors.randomElement()!
    }
}

extension MainController: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimerCell", for: indexPath as IndexPath) as! TimerCell
        
        cell.setUpWith(clTimer: timers[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
    }
}

extension Date {
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
