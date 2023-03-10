// GITHUB BAK
// YAPILACAKLAR KONTROL ET
// 1-) Mola suresinde dakikalar saniyenin 00'i ile eslestiginde tek basamak olarak gozukuyor. Cift basamak olmali. (ACILIYETI YOK AMA UNUTMA)
//!!!!! 2-) Sayac calisiyor fakat 1. dongu bittikten sonra istedigimiz sureye gecmiyor. DUZELT !!!  ONEMLI
// 3-) Sure bittikten sonra tekrar baslatirsak. 24 yerine 25'ten basliyor. Duzeltilmesi lazim.

//  ViewController.swift
//  Stay Focus
//
//  Created by Kerem Demır on 15.02.2023.
//

import UIKit
class ViewController: UIViewController {
    
    var focusMinutesTimer = Timer()
    var shortMinutesTimer = Timer()
    
    var secondsTimer = Timer()
    
    let startButton = SFActionButton()
    let pauseButton = SFActionButton()
    let stopButton = SFActionButton()
    
    var focusMinutesLabel = SFTimeLabel(text: "25")
    let secondsLabel = SFTimeLabel(text: "00")
    
    var shortMinutesLabel = SFTimeLabel(text: "05")
    
    var pauseMu:Bool = true
    
    var counter:Int = 0
    
    let focusView = SFView(text: "Focus")
    let breakView = SFView(text: "Break")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        pauseButton.isHidden = true
        stopButton.isHidden = true
        shortMinutesLabel.isHidden = true
        
        breakView.isHidden = true
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configure(){
        configureUI()
        rightBarButtonItem()
        configureSFViews()
    }
    
    private func rightBarButtonItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "slider30px"), style: .plain, target: self, action: #selector(settingsAction))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    @objc func settingsAction(){
        let rootVC = SettingsVC()
        rootVC.callBackForSomething = { value in
            self.focusMinutesLabel.text = "\(Int(value.focusTime))"
            self.shortMinutesLabel.text = "\(Int(value.shortBreakTime))"
        }
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    //MARK: - Start Button Actions
    @objc func startButtonActions(){
        print("Start butonu calisti.")
        
        print("Counter : \(counter)")
        
        print("Focus Time       : \(focusMinutesLabel.text!)")
        print("Short Break Time : \(shortMinutesLabel.text!)")
        
        startButton.isHidden = true
        pauseButton.isHidden = false
        stopButton.isHidden = false
        
        let minutesTimeValue = Int(focusMinutesLabel.text!)!
        focusMinutesLabel.text = String(minutesTimeValue - 1)
        secondsLabel.text = "09"
        
        //MARK: - Seconds Label Work Method
        secondsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(secondsTimerStart), userInfo: nil, repeats: true)
        
        //MARK: - Focus Minutes Label Work Method
        focusMinutesTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(focusMinutesTimerStart), userInfo: nil, repeats: true)
        
        //MARK: - Break Minutes Label Work Method
        shortMinutesTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(shortMinutesTimerStart), userInfo: nil, repeats: true)
    }
    
    //MARK: - Focus Minutes Timer Set
    @objc func focusMinutesTimerStart(){
        focusMinutesLabel.isHidden = false
        shortMinutesLabel.isHidden = true
        var focusMinutesTimeValue = Int(focusMinutesLabel.text!)!
        focusMinutesLabel.text = String(focusMinutesTimeValue - 1)
        focusMinutesTimeValue -= 1
        focusMinutesLabel.text = String(focusMinutesTimeValue)
        
        //MARK: - Label 0'dan kucuk kontrolu.
        if (focusMinutesTimeValue < 10){
            focusMinutesLabel.text = "0\(focusMinutesTimeValue)"
            if focusMinutesTimeValue == -1 {
                focusMinutesLabel.text = "00"
            }
        }
    }
    
    //MARK: - Short Minutes Timer Set
    @objc func shortMinutesTimerStart(){
        focusMinutesLabel.isHidden = true
        shortMinutesLabel.isHidden = false
        var shortTimeValue = Int(shortMinutesLabel.text!)!
        secondsLabel.text = "09"
        shortMinutesLabel.text = String(shortTimeValue)
        shortTimeValue -= 1
        shortMinutesLabel.text = String(shortTimeValue)
        
        if ( shortTimeValue < 10){
            shortMinutesLabel.text = "0\(shortTimeValue)"
            if shortTimeValue == -1 {
                shortMinutesLabel.text = "00"
                focusMinutesLabel.isHidden = false
                shortMinutesLabel.isHidden = true
            }
        }
    }
    
    //MARK: - Seconds Time Set
    @objc func secondsTimerStart(){
        let minutesTimeValue = Int(focusMinutesLabel.text!)!
        let shortTimeValue = Int(shortMinutesLabel.text!)!
        var secondsTimeValue = Int(secondsLabel.text!)!
        
        if secondsTimeValue == 00 {
            secondsTimeValue = 10
        }
        
        secondsTimeValue -= 1
        secondsLabel.text = String(secondsTimeValue)
        
        if (secondsTimeValue == 0 && minutesTimeValue == 0){
            focusView.isHidden = true
            breakView.isHidden = false
            focusMinutesLabel.isHidden = true
            shortMinutesLabel.isHidden = false
            shortMinutesLabel.text = String(shortTimeValue)
            
            if (shortTimeValue == 0 && secondsTimeValue == 00){
                focusMinutesLabel.isHidden = false
                shortMinutesLabel.isHidden = true
                counter += 1
                print("Cycle Counter : \(counter)")
                if (counter == 1 || counter == 2 || counter == 3){
                    focusMinutesTimerStart()
                    shortMinutesTimerStart()
                    print("Dongu yeniden basladi.")
                }
                if (counter == 4 ){
                    done()
                }
            }
        }
        //MARK: - Label 0'dan kucuk kontrolu.
        if (secondsTimeValue < 10){
            secondsLabel.text = "0\(secondsTimeValue)"
        }
    }
    
    private func done(){
        secondsTimer.invalidate()
        focusMinutesTimer.invalidate()
        shortMinutesTimer.invalidate()
        print("Bitti")
        
        startButton.isHidden = false
        
        pauseButton.isHidden = true
        stopButton.isHidden = true
        
        focusView.isHidden = false
        breakView.isHidden = true
        
        focusMinutesLabel.text = "25" // Kontrol et ikisini de
        shortMinutesLabel.text = "25"
        print("Done -> Cycle Counter : \(counter)")

        // Dongu burda bitiyor.
    }
    
    @objc func pauseButtonActions(){
        focusMinutesTimer.invalidate()
        secondsTimer.invalidate()
        shortMinutesTimer.invalidate()
        
        if pauseMu == true {
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            print("Stopped.")
            pauseMu = false
        }
        
        else if pauseMu == false {
            pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            focusMinutesTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(focusMinutesTimerStart), userInfo: nil, repeats: true)
            secondsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(secondsTimerStart), userInfo: nil, repeats: true)
            shortMinutesTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(shortMinutesTimerStart), userInfo: nil, repeats: true)
            
            print("Continues.")
            pauseMu = true
        }
        
    }
    
    @objc func stopButtonActions(){
        showAlert(
            title: "Alert",
            message: "Are you sure you want to finish Pomodoro?",
            handlerYes: { action in
                print("Done")
                
                self.pauseButton.isHidden = true
                self.stopButton.isHidden = true
                self.startButton.isHidden = false
                
                self.focusMinutesLabel.isHidden = false
                self.shortMinutesLabel.isHidden = true
                
                self.focusMinutesTimer.invalidate()
                self.secondsTimer.invalidate()
                self.shortMinutesTimer.invalidate()
                
                self.focusMinutesLabel.text = "25"
                self.secondsLabel.text = "00"
            },
            handlerCancel: { actionCancel in
                // Cancel edildigine aksiyon olmicak.
            })}
    
    
    
    private func configureSFViews(){
        view.addSubview(focusView)
        focusView.stateImage.image = UIImage(named: "Focus")
        NSLayoutConstraint.activate([
            focusView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            focusView.widthAnchor.constraint(equalToConstant: 35),
            focusView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200)
        ])
        
        view.addSubview(breakView)
        breakView.stateImage.image = UIImage(named: "Break")
        NSLayoutConstraint.activate([
            breakView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            breakView.widthAnchor.constraint(equalToConstant: 35),
            breakView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200)
        ])
    }
    
    private func configureUI(){
        startButton.addTarget(self, action: #selector(startButtonActions), for: .touchUpInside)
        view.addSubview (startButton)
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 600),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 70),
            startButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        view.addSubview(focusMinutesLabel)
        NSLayoutConstraint.activate([
            focusMinutesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            focusMinutesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            focusMinutesLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        view.addSubview(shortMinutesLabel)
        NSLayoutConstraint.activate([
            shortMinutesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            shortMinutesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shortMinutesLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        view.addSubview(secondsLabel)
        NSLayoutConstraint.activate([
            secondsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 430),
            secondsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondsLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        view.addSubview(pauseButton)
        pauseButton.backgroundColor = .systemGreen
        pauseButton.addTarget(self, action: #selector(pauseButtonActions), for: .touchUpInside)
        pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 600),
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            pauseButton.heightAnchor.constraint(equalToConstant: 70),
            pauseButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        view.addSubview(stopButton)
        stopButton.backgroundColor = .red
        stopButton.addTarget(self, action: #selector(stopButtonActions), for: .touchUpInside)
        stopButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 600),
            stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -110),
            stopButton.widthAnchor.constraint(equalToConstant: 70),
            stopButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}

extension UIViewController {
    func showAlert(title: String, message: String, handlerYes: ((UIAlertAction) -> Void)?, handlerCancel: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .destructive, handler: handlerYes)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: handlerCancel)
        alert.addAction(action)
        alert.addAction(actionCancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
