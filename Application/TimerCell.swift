//
//  TimerCell.swift
//  Cortland
//
//  Created by Grant Brooks Goodman on 20/05/2021.
//  Copyright © 2013-2021 NEOTechnica Corporation. All rights reserved.
//

/* First-party Frameworks */
import UIKit

class TimerCell: UICollectionViewCell {
    
    //==================================================//
    
    /* MARK: - - Interface Builder UI Elements */
    
    //CircularButtons
    @IBOutlet weak var playPauseButton: CircularButton!
    @IBOutlet weak var settingsButton: CircularButton!
    @IBOutlet weak var resetButton: CircularButton!
    
    //UILabels
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    //Other Elements
    @IBOutlet weak var progressView: CircularProgressView!
    
    //==================================================//
    
    /* MARK: - - Class-level Variable Declarations */
    
    private var timer: Timer?
    private var flashRepetitions = 0
    
    private var alarmLabelTimer: Timer?
    
    var seconds: Int!
    //private var originalSeconds: Int!
    
    private var clTimer: CLTimer!
    
    //==================================================//
    
    /* MARK: - - Structures */
    
    struct ButtonBackgroundColor {
        static let play = UIColor(hex: 0x002514)
        static let pause = UIColor(hex: 0x302007)
        static let reset = UIColor(hex: 0x2F100F)
        static let settings = UIColor(hex: 0x424118)
    }
    
    struct ButtonTintColor {
        static let play = UIColor(hex: 0x00C554)
        static let pause = UIColor(hex: 0xFF962C)
        static let reset = UIColor(hex: 0xF73837)
        static let settings = UIColor(hex: 0xFFF200)
    }
    
    //==================================================//
    
    /* MARK: - - Overridden Functions */
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        playPauseButton.backgroundColor = ButtonBackgroundColor.play
        settingsButton.backgroundColor = ButtonBackgroundColor.settings
        resetButton.backgroundColor = ButtonBackgroundColor.reset
        
        playPauseButton.tintColor = ButtonTintColor.play
        settingsButton.tintColor = ButtonTintColor.settings
        resetButton.tintColor = ButtonTintColor.reset
        
        resetButton.isEnabled = false
        
        layer.backgroundColor = UIColor(hex: 0x353536).cgColor //UIColor(hex: 0x2D3436).cgColor
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 10
        layer.cornerRadius = 5
        
        titleLabel.layer.cornerRadius = 10
        titleLabel.clipsToBounds = true
        
        progressView.backgroundColor = .clear
    }
    
    //==================================================//
    
    /* MARK: - - Core Functions */
    
    func setUpWith(clTimer: CLTimer) {
        self.clTimer = clTimer
        
        updateDuration()
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        
        //seconds = originalSeconds
        
        titleLabel.text = "«\(clTimer.title.uppercased())»"
        timeRemainingLabel.text = "..."
        
        alarmLabel.text = timeFormatter.string(from: clTimer.alarmDate!)
    }
    
    // TODO: Fix bugs with this
    func updateDuration() {
        if clTimer.alarmDate < Date().startOfMinute || clTimer.alarmDate == Date().startOfMinute {
            clTimer.alarmDate = clTimer.alarmDate.oneDayAdvanced
        }
        
        seconds = clTimer.alarmDate!.seconds(from: Date())
        
        progressView.progressAnimation(duration: TimeInterval(seconds))
    }
    
    func start() {
        updateDuration()
        showAttributes()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decrement), userInfo: nil, repeats: true)
        
        progressView.progressAnimation(duration: TimeInterval(seconds))
        progressView.resumeAnimation()
        
        showPauseButton()
    }
    
    func resume() {
        updateDuration()
        showAttributes()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decrement), userInfo: nil, repeats: true)
        
        progressView.resumeAnimation()
        showPauseButton()
    }
    
    func pause() {
        hideAttributes()
        updateDuration()
        
        if let timer = self.timer {
            timer.invalidate()
        }
        
        progressView.pauseAnimation()
        showPlayButton()
    }
    
    func reset() {
        hideAttributes()
        updateDuration()
        
        if let timer = self.timer {
            timer.invalidate()
        }
        
        //seconds = originalSeconds
        
        progressView.progressAnimation(duration: TimeInterval(seconds))
        showPlayButton()
    }
    
    //==================================================//
    
    /* MARK: - - Interface Builder Actions */
    
    @IBAction func playPauseButton(_ sender: Any) {
        if timer != nil {
            if playPauseButton.backgroundColor == ButtonBackgroundColor.play {
                resume()
            } else {
                pause()
            }
        }
        else {
            start()
        }
        
        resetButton.isEnabled = true
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        
    }
    
    @IBAction func resetButton(_ sender: Any) {
        reset()
        resetButton.isEnabled = false
    }
    
    //==================================================//
    
    /* MARK: - - Layout Functions */
    
    func showAttributes() {
        UIView.animate(withDuration: 0.5) {
            self.progressView.alpha = 1
        }
        
        UIView.transition(with: self.timeRemainingLabel, duration: 0.5, options: .transitionCrossDissolve) {
            self.timeRemainingLabel.text = self.seconds.timeValue()
        }
    }
    
    func hideAttributes() {
        UIView.animate(withDuration: 0.5) {
            self.progressView.alpha = 0
        }
        
        UIView.transition(with: self.timeRemainingLabel, duration: 0.5, options: .transitionCrossDissolve) {
            self.timeRemainingLabel.text = "..."
        }
    }
    
    func showPlayButton() {
        let playImage = UIImage(systemName: "play.fill")
        playPauseButton.setImage(playImage, for: .normal)
        
        playPauseButton.backgroundColor = ButtonBackgroundColor.play
        playPauseButton.tintColor = ButtonTintColor.play
    }
    
    func showPauseButton() {
        let pauseImage = UIImage(systemName: "pause.fill")
        playPauseButton.setImage(pauseImage, for: .normal)
        
        playPauseButton.backgroundColor = ButtonBackgroundColor.pause
        playPauseButton.tintColor = ButtonTintColor.pause
    }
    
    //==================================================//
    
    /* MARK: - - Timer-triggered Functions */
    
    @objc func decrement() {
        seconds -= 1
        
        DispatchQueue.main.async {
            self.timeRemainingLabel.text = self.seconds.timeValue()
        }
        
        if seconds == 0,
           let timer = self.timer {
            timer.invalidate()
            flash()
        }
    }
    
    @objc func flash() {
        let backgroundIsNormal = layer.backgroundColor == UIColor(hex: 0x2D3436).cgColor
        
        if backgroundIsNormal {
            layer.backgroundColor = UIColor.orange.cgColor
        } else if !backgroundIsNormal {
            layer.backgroundColor = UIColor(hex: 0x2D3436).cgColor
        }
        
        if flashRepetitions < 9 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(800)) {
                self.flashRepetitions += 1
                self.flash()
            }
        }
    }
}

//==================================================//

/* MARK: - - Extensions */

/**/

/* MARK: - Int */
extension Int {
    func timeValue() -> String {
        let hours = self / 3600
        let minutes = self / 60 % 60
        let seconds = self % 60
        
        if hours < 0 || minutes < 0 || seconds < 0 {
            if hours == 0 {
                return "00:00"
            } else {
                return "00:00:00"
            }
        }
        
        if hours == 0 {
            return String(format:"%02i:%02i", minutes, seconds)
        }
        
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}

/* MARK: - Date */
extension Date {
    var startOfMinute: Date {
        return currentCalendar.date(bySetting: .second, value: 0, of: self)!
    }
    
    var oneDayAdvanced: Date {
        return currentCalendar.date(byAdding: .day, value: 1, to: self)!
    }
}
