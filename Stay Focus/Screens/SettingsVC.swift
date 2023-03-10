//
//  SettingsVC.swift
//  Stay Focus
//
//  Created by Kerem Demır on 15.02.2023.
//

import UIKit

struct SlidersModel {
    let focusTime: Float
    let shortBreakTime: Float
}

class SettingsVC: UIViewController {
    
    //MARK: - Focus Time Labels
    let focusTimeSliderLabel:UILabel = {
        let focusTimeSliderLabel = UILabel()
        focusTimeSliderLabel.translatesAutoresizingMaskIntoConstraints = false
        focusTimeSliderLabel.text = "Focus Time"
        focusTimeSliderLabel.textColor = .label
        focusTimeSliderLabel.font = .systemFont(ofSize: 20.0)
        return focusTimeSliderLabel
    }()
    
     let focusTimeSliderValueLabel:UILabel = {
        let focusTimeSliderValueLabel = UILabel()
        focusTimeSliderValueLabel.translatesAutoresizingMaskIntoConstraints = false
        focusTimeSliderValueLabel.text = "20"
        focusTimeSliderValueLabel.textColor = .label
        focusTimeSliderValueLabel.font = .systemFont(ofSize: 20.0)
        return focusTimeSliderValueLabel
    }()
    
    //MARK: - Short Break Time Labels
    let shortBreakTimeSliderLabel:UILabel = {
        let focusTimeSliderLabel = UILabel()
        focusTimeSliderLabel.translatesAutoresizingMaskIntoConstraints = false
        focusTimeSliderLabel.text = "Short Break Time"
        focusTimeSliderLabel.textColor = .label
        focusTimeSliderLabel.font = .systemFont(ofSize: 20.0)
        return focusTimeSliderLabel
    }()
    
    let shortBreakTimeSliderValueLabel:UILabel = {
        let focusTimeSliderValueLabel = UILabel()
        focusTimeSliderValueLabel.translatesAutoresizingMaskIntoConstraints = false
        focusTimeSliderValueLabel.text = "5"
        focusTimeSliderValueLabel.textColor = .label
        focusTimeSliderValueLabel.font = .systemFont(ofSize: 20.0)
        return focusTimeSliderValueLabel
    }()
    
    //MARK: - Sliders
    
    var focusTimeSlider = UISlider()
    let shortBreakTimeSlider = UISlider()
    
//    var callBackForSomething: ((Float)-> ())?
    var callBackForSomething: ((SlidersModel)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        
        configure()
    }
    
    private func configure(){
        addCloseButton()
        
        layoutFocusTime()
        layoutShortBreakTime()
        
        layoutFocusTimeSlider()
        layoutShortBreakTimeSlider()
    }
    
    //MARK: - Bitti Butonu
    func addCloseButton(){
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClose))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func onClose(sender: AnyObject){
        
        self.dismiss(animated: true, completion: nil)
        
        callBackForSomething?(SlidersModel(focusTime: focusTimeSlider.value, shortBreakTime: shortBreakTimeSlider.value))
        
        print("Focus Time       : \(Int(focusTimeSlider.value))")
        print("Short Break Time : \(Int(shortBreakTimeSlider.value))")
        
    }
    
    
    //MARK: - Slider Actions
    
    func layoutFocusTimeSlider(){
        focusTimeSlider.addTarget(self, action: #selector(focusSliderValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func focusSliderValueChanged(sender: UISlider){
        focusTimeSliderValueLabel.text = String(Int(focusTimeSlider.value))
    }
    
    func layoutShortBreakTimeSlider(){
        shortBreakTimeSlider.addTarget(self, action: #selector(shortSliderValueChanged), for: .valueChanged)
    }
    
    @objc func shortSliderValueChanged(){
        shortBreakTimeSliderValueLabel.text = String(Int(shortBreakTimeSlider.value))
    }
}

//MARK: - Extensions

extension SettingsVC {
    func layoutFocusTime(){
        view.addSubview(focusTimeSliderLabel)
        NSLayoutConstraint.activate([
            focusTimeSliderLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
            focusTimeSliderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        
        view.addSubview(focusTimeSliderValueLabel)
        NSLayoutConstraint.activate([
            focusTimeSliderValueLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
            focusTimeSliderValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        
        focusTimeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        focusTimeSlider.minimumValue = 1
        focusTimeSlider.maximumValue = 40
        
        focusTimeSlider.tintColor = .systemPink
        
        view.addSubview(focusTimeSlider)
        NSLayoutConstraint.activate([
            focusTimeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            focusTimeSlider.topAnchor.constraint(equalTo: view.topAnchor, constant: 170),
            focusTimeSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    func layoutShortBreakTime(){
        view.addSubview(shortBreakTimeSliderLabel)
        NSLayoutConstraint.activate([
            shortBreakTimeSliderLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            shortBreakTimeSliderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        
        view.addSubview(shortBreakTimeSliderValueLabel)
        NSLayoutConstraint.activate([
            shortBreakTimeSliderValueLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            shortBreakTimeSliderValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        
        shortBreakTimeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        shortBreakTimeSlider.minimumValue = 2
        shortBreakTimeSlider.maximumValue = 15
        
        shortBreakTimeSlider.tintColor = .systemPink
        
        view.addSubview(shortBreakTimeSlider)
        NSLayoutConstraint.activate([
            shortBreakTimeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shortBreakTimeSlider.topAnchor.constraint(equalTo: view.topAnchor, constant: 295),
            shortBreakTimeSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    

}
