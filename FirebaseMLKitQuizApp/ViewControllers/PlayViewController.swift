//
//  PlayViewController.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 30.12.2023.
//

import Foundation
import UIKit
import CoreData
import AVFoundation
import MLKitVision
import MLKitFaceDetection

class PlayViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var userName: String = ""
    var chosenCategory: Int = 0
    var allQuestions = [Question]()
    var categoryQuestions = [Question]()
    var fiveRandomCategoryQuestions = [Question]()
    var currentQuestionNumber: Int = 0
    var answeredQuestionCount: Int = 0
    var correctAnswerCount: Int = 0
    
    var faceTurnedRightThreshold: CGFloat = -10.0
    var faceTurnedLeftThreshold: CGFloat = 10.0
    
    var videoView = UIView()
    var otherView = UIView()
    
    var disableCalls: Bool = false
    var timerInt: Int = 10
    var timer = Timer()
    
    var playViewTitleLabel: UILabel = {
        return CustomLabels().styleStandardLabel(text: "Turn your head to answer", textColor: .systemIndigo, strokeColor: .black, fontSize: 26, isBold: true)
    }()
    var questionLabel: UILabel = {
        return CustomLabels().styleStandardLabel(text: "Question", textColor: .systemIndigo, strokeColor: .black, fontSize: 26, isBold: true)
    }()
    var leftAnswerButton: UIButton = {
        let tempButton = CustomButtons().styleStandardButton(title: "Left Answer", titleColor: UIColor.white, backgroundColor: UIColor.systemIndigo)
        return tempButton
        
    }()
    var rightAnswerButton: UIButton = {
        let tempButton = CustomButtons().styleStandardButton(title: "Right Answer", titleColor: UIColor.white, backgroundColor: UIColor.systemIndigo)
        return tempButton
    }()
    var timerLabel: UILabel = {
        return CustomLabels().styleStandardLabel(text: "10", textColor: .systemIndigo, strokeColor: .black, fontSize: 26, isBold: true)
    }()
    
    // MARK: Firebase face detecting
    public weak var faceDetectingProtocol: FaceDetectingProtocol?
    
    private let captureDevice: AVCaptureDevice? = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    private lazy var captureVideoDataOutput: AVCaptureVideoDataOutput = {
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.alwaysDiscardsLateVideoFrames = true
        dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        dataOutput.connection(with: .video)?.isEnabled = true
        return dataOutput
    }()
    private let videoDataOutputQueue: DispatchQueue = DispatchQueue(label: "VideoDataOutputQueue")
    private lazy var faceDetectorOptions: FaceDetectorOptions = {
        let options = FaceDetectorOptions()
        options.performanceMode = .accurate
        options.landmarkMode = .none
        options.classificationMode = .all
        options.isTrackingEnabled = false
        options.contourMode = .none
        return options
    }()
    private lazy var videoLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    private lazy var session: AVCaptureSession = {
        return AVCaptureSession()
    }()
    func sessionStart() {
        guard let captureDevice = self.captureDevice else { return }
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        if self.session.canAddInput(captureDeviceInput) {
            self.session.addInput(captureDeviceInput)
        }
        if self.session.canAddOutput(captureVideoDataOutput) {
            self.session.addOutput(captureVideoDataOutput)
        }
        
        
        self.view.layer.masksToBounds = true
        self.videoView.layer.addSublayer(self.videoLayer)
        self.videoLayer.frame = self.view.layer.frame
        
        
        DispatchQueue.global().async {
            self.session.startRunning()
        }
        
    }
    func sessionEnd() {
        self.session.stopRunning()
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer.")
            return
        }
        let visionImage = VisionImage(buffer: sampleBuffer)
        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
        DispatchQueue.global().async {
            self.detectFacesOnDevice(in: visionImage,
                                     width: imageWidth,
                                     height: imageHeight)
        }
    }
    
    private func detectFacesOnDevice(in image: VisionImage, width: CGFloat, height: CGFloat) {
        let faceDetector = FaceDetector.faceDetector(options: self.faceDetectorOptions)
        faceDetector.process(image, completion: { features, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard error == nil, let features = features, !features.isEmpty else {
                return
            }
            if let face = features.first {
                if face.headEulerAngleY > self.faceTurnedLeftThreshold {
                    if self.disableCalls == false {
                        DispatchQueue.main.async {
                            self.disableCalls = true
                            self.faceTiltedLeft()
                        }
                    }
                } else if face.headEulerAngleY < self.faceTurnedRightThreshold {
                    if self.disableCalls == false {
                        DispatchQueue.main.async {
                            self.disableCalls = true
                            self.faceTiltedRight()
                        }
                    }
                }
                
                
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readJsonAndFetchCategoryQuestions()
        self.sessionStart()
        setPlayView()
        playGame()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.sessionEnd()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.sessionEnd()
    }
}

// MARK: Timer functions
extension PlayViewController {
    func timerStarted() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        if self.timerInt > 0 {
            self.timerInt -= 1
            self.timerLabel.text = String(self.timerInt)
        } else {
            timerRanOut()
        }
    }
    func timerRanOut() {
        AudioServicesPlaySystemSound(1111)
        self.timer.invalidate()
        self.showCorrectAnswerAfterTimerRanOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.answeredQuestionCount += 1
            self.currentQuestionNumber += 1
            self.resetAnswerColors()
            self.timerStarted()
            self.setNewQuestionToView()
        }
    }
}

// MARK: Display correct answer after timer ran out
extension PlayViewController {
    func showCorrectAnswerAfterTimerRanOut() {
        let correctAnswer: Int = fiveRandomCategoryQuestions[self.currentQuestionNumber].correctAnswer
        if correctAnswer == 0 {
            showCorrectAnswerOnButton(button: self.leftAnswerButton)
            showFalseAnswerOnButton(button: self.rightAnswerButton)
        } else if correctAnswer == 1 {
            showFalseAnswerOnButton(button: self.leftAnswerButton)
            showCorrectAnswerOnButton(button: self.rightAnswerButton)
        }
    }
    func showCorrectAnswerOnButton(button: UIButton) {
        button.backgroundColor = .systemGreen
    }
    func showFalseAnswerOnButton(button: UIButton) {
        button.backgroundColor = .systemRed
    }
    func resetAnswerColors() {
        self.leftAnswerButton.backgroundColor = .systemIndigo
        self.rightAnswerButton.backgroundColor = .systemIndigo
    }
}


// MARK: Face detection selectors
@objc protocol FaceDetectingProtocol: AnyObject {
    @objc optional func faceTiltedRight()
    @objc optional func faceTiltedLeft()
}

// MARK: Face detection selector functions
extension PlayViewController: FaceDetectingProtocol {
    func faceTiltedRight() {
        self.rightAnswerChosen()
    }
    func faceTiltedLeft() {
        self.leftAnswerChosen()
    }
}

// MARK: PlayView setup
extension PlayViewController {
    func setPlayView() {
        self.view.backgroundColor = .black
        navigationItem.titleView = playViewTitleLabel
        addButtonTargets()
        self.otherView.addSubview(questionLabel)
        self.otherView.addSubview(leftAnswerButton)
        self.otherView.addSubview(rightAnswerButton)
        self.otherView.addSubview(timerLabel)
        self.view.addSubview(videoView)
        self.view.addSubview(otherView)
        
        self.setConstraints()
    }
}

// MARK: Gameplay setup
extension PlayViewController {
    func playGame() {
        self.selectFiveRandomQuestions()
        self.setNewQuestionToView()
        self.timerStarted()
    }
}

// MARK: Preparing 5 random questions out of a category
extension PlayViewController {
    func selectFiveRandomQuestions() {
        let tempShuffledCategoryQuestions = categoryQuestions.shuffled()
        fiveRandomCategoryQuestions = Array(tempShuffledCategoryQuestions.prefix(5))
    }
}

// MARK: Answer selection actions
extension PlayViewController {
    @objc func leftAnswerChosen() {
        evaluateSelectedAnswer(isRightSideSelected: 0)
        setNewQuestionToView()
    }
    @objc func rightAnswerChosen() {
        evaluateSelectedAnswer(isRightSideSelected: 1)
        setNewQuestionToView()
    }
    func setNewQuestionToView() {
        if self.answeredQuestionCount < self.fiveRandomCategoryQuestions.count {
            self.timerInt = 10
            self.questionLabel.text = fiveRandomCategoryQuestions[self.currentQuestionNumber].question
            self.leftAnswerButton.setTitle(fiveRandomCategoryQuestions[self.currentQuestionNumber].answerLeft, for: .normal)
            self.rightAnswerButton.setTitle(fiveRandomCategoryQuestions[self.currentQuestionNumber].answerRight, for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.disableCalls = false
            }
        } else {
            self.disableCalls = true
            self.sessionEnd()
            prepareFinishedGameScoreSaving()
        }
    }
}

// MARK: Score tracking
extension PlayViewController {
    func evaluateSelectedAnswer(isRightSideSelected: Int) {
        print("evaluating answer")
        if self.currentQuestionNumber < 5 {
            let correctAnswer: Int = fiveRandomCategoryQuestions[self.currentQuestionNumber].correctAnswer
            if isRightSideSelected == correctAnswer {
                // if both are 1 user selected rightside and was correct
                // if both are 0 user selected leftside and was correct
                AudioServicesPlaySystemSound(1407)
                correctAnswerSelected()
            } else {
                // else user selected incorrect answer
                AudioServicesPlaySystemSound(1073)
                falseAnswerSelected()
            }
        } else {
            print("called more than 5")
        }
    }
    func correctAnswerSelected() {
        self.correctAnswerCount += 1
        self.answeredQuestionCount += 1
        self.currentQuestionNumber += 1
    }
    func falseAnswerSelected() {
        self.answeredQuestionCount += 1
        self.currentQuestionNumber += 1
    }
    func prepareFinishedGameScoreSaving() {
        self.timer.invalidate()
        let date: Date = Date.now
        SaveScore().saveNewScore(userName: self.userName, category: self.chosenCategory, totalQuestionCount: self.answeredQuestionCount, correctAnswerCount: self.correctAnswerCount, quizDate: date)
        navigateToScoreboard(date: date)
    }
}

// MARK: PlayView constraints
extension PlayViewController {
    func setConstraints() {
        setOtherViewConstraints()
        setQuestionLabelConstraints()
        setLeftAnswerButtonConstraints()
        setRightAnswerButtonConstraints()
        setTimerLabelConstraints()
    }
    func setOtherViewConstraints() {
        self.otherView.frame = self.view.frame
    }
    func setQuestionLabelConstraints() {
        let questionLabelConstraints = [
            self.questionLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.questionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(questionLabelConstraints)
    }
    func setLeftAnswerButtonConstraints() {
        let leftAnswerButtonConstraints = [
            self.leftAnswerButton.heightAnchor.constraint(equalToConstant: 75),
            self.leftAnswerButton.widthAnchor.constraint(equalToConstant: 120),
            //self.leftAnswerButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.leftAnswerButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            self.leftAnswerButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        ]
        NSLayoutConstraint.activate(leftAnswerButtonConstraints)
    }
    func setRightAnswerButtonConstraints() {
        let rightAnswerButtonConstraints = [
            self.rightAnswerButton.heightAnchor.constraint(equalToConstant: 75),
            self.rightAnswerButton.widthAnchor.constraint(equalToConstant: 120),
            //self.rightAnswerButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.rightAnswerButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            self.rightAnswerButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(rightAnswerButtonConstraints)
    }
    func setTimerLabelConstraints() {
        self.timerLabel.textAlignment = .center
        let timerLabelConstraints = [
            self.timerLabel.heightAnchor.constraint(equalToConstant: 40),
            self.timerLabel.widthAnchor.constraint(equalToConstant: 50),
            self.timerLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.timerLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
        ]
        NSLayoutConstraint.activate(timerLabelConstraints)
    }
}

// MARK: Add button targets
extension PlayViewController {
    func addButtonTargets() {
        self.leftAnswerButton.addTarget(self, action: #selector(leftAnswerChosen), for: .touchUpInside)
        self.rightAnswerButton.addTarget(self, action: #selector(rightAnswerChosen), for: .touchUpInside)
    }
}

// MARK: Reading json and fetching category questions
extension PlayViewController {
    func readJsonAndFetchCategoryQuestions() {
        readJson()
        filterCategoryQuestions()
    }
    func readJson() {
        if let questionsUrl = Bundle.main.url(forResource: "AllQuestionsFromAllCategories", withExtension: "json") {
            do {
                let rawData = try Data(contentsOf: questionsUrl)
                let jsonData = try JSONDecoder().decode(QuestionSet.self, from: rawData)
                allQuestions = jsonData.questions
            } catch {
                print(error)
            }
        }

    }
    func filterCategoryQuestions() {
        for q in allQuestions {
            if q.category == chosenCategory {
                categoryQuestions.append(q)
            }
        }
        print(categoryQuestions)
    }
}

// MARK: Navigate to Scoreboard
extension PlayViewController {
    func navigateToScoreboard(date: Date) {
        self.sessionEnd()
        let scoreboardViewController = ScoreboardViewController()
        scoreboardViewController.date = date
        navigationController?.pushViewController(scoreboardViewController, animated: true)
    }
}
