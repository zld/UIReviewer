//
//  ViewController.swift
//  UIReviewer
//
//  Created by zld on 2019/5/7.
//  Copyright © 2019 zld. All rights reserved.
//

import Cocoa
import Quartz
import AppKit

class ViewController: NSViewController, NSComboBoxDelegate {

    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var openFileButton: NSButton!
    @IBOutlet weak var useClipboardButton: NSButton!
    @IBOutlet weak var selectPhoneBox: NSComboBox!
    @IBOutlet weak var opacitySlider: NSSlider!
    @IBOutlet weak var imageViewDescLabel: NSTextField!
    @IBOutlet weak var picInfoDescLabel: NSTextField!
    @IBOutlet weak var divide2Btn: NSButton!
    @IBOutlet weak var divide3Btn: NSButton!
    @IBOutlet weak var divide1Btn: NSButton!
    
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    var currentImageScale: Int!

    var selectedImage: NSImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectPhoneBox.delegate = self
        currentImageScale = 1
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func openFileAction(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.showsResizeIndicator = true
        openPanel.showsHiddenFiles = false
        openPanel.allowedFileTypes = ["jpg", "jpeg", "JPG", "JPEG", "png", "PNG", "tiff", "tif", "TIFF", "TIF"];
        if (openPanel.runModal() == .OK) {
            let result = openPanel.url
            if (result != nil) {
                selectedImage = NSImage.init(contentsOf: result!)
                imageView.image = selectedImage
                descImageInfo()
            }
        }
    }
    
    @IBAction func useClipboardImageAction(_ sender: Any) {
        let pasteboard = NSPasteboard.general
        guard let image = NSImage.init(pasteboard: pasteboard) else {
            return;
        }
        imageView.image = image
        selectedImage = image
        descImageInfo()
    }

    @IBAction func opacitySliderAction(_ sender: NSSlider) {
        let opacity = sender.floatValue
        self.view.window?.alphaValue = CGFloat.init(opacity)
    }
    
    @IBAction func divide2(_ sender: NSButton) {
        if (sender.state == .on) {
            divide3Btn.state = .off
            divide1Btn.state = .off
            resizeAndDisplay(scale: 2)
        }
    }
    
    @IBAction func divide3(_ sender: NSButton) {
        if (sender.state == .on) {
            divide2Btn.state = .off
            divide1Btn.state = .off
            resizeAndDisplay(scale: 3)
        }
    }
    
    @IBAction func divide1(_ sender: NSButton) {
        if (sender.state == .on) {
            divide2Btn.state = .off
            divide3Btn.state = .off
            resizeAndDisplay(scale: 1)
        }
    }
    
    func resizeAndDisplay(scale: Int) {
        if currentImageScale == scale || selectedImage == nil {
            return
        }
        let resizedImage = resize(image: selectedImage!, w: Int((selectedImage?.size.width)!/CGFloat(scale)), h: Int((selectedImage?.size.height)!/CGFloat(scale)))
        imageView.image = resizedImage
        currentImageScale = scale
        descImageInfo()
    }
    
    func resize(image: NSImage, w: Int, h: Int) -> NSImage {
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: .sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        return NSImage(data: newImage.tiffRepresentation!)!
    }
    
    func descImageInfo() {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        let size = imageView.image?.size ?? NSZeroSize
        let w  = formatter.string(from: NSNumber.init(value: Float(size.width))) ?? "0"
        let h  = formatter.string(from: NSNumber.init(value: Float(size.height))) ?? "0"
        let w2 = formatter.string(from: NSNumber.init(value: Float(size.width/2))) ?? "0"
        let h2 = formatter.string(from: NSNumber.init(value: Float(size.height/2))) ?? "0"
        let w3 = formatter.string(from: NSNumber.init(value: Float(size.width/3))) ?? "0"
        let h3 = formatter.string(from: NSNumber.init(value: Float(size.height/3))) ?? "0"
        picInfoDescLabel.stringValue = String.init(format: "px:  %@, %@\n÷2: %@, %@\n÷3: %@, %@", w, h, w2, h2, w3, h3)
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        let index = selectPhoneBox.indexOfSelectedItem
        if (index == 1) {
            // Plus
            imageViewWidth.constant = 540
            imageViewHeight.constant = 960
        } else if (index == 2) {
            // X/Xs
            imageViewWidth.constant = 562.5
            imageViewHeight.constant = 1218
        } else if (index == 3) {
            // XR
            imageViewWidth.constant = 414
            imageViewHeight.constant = 896
        } else if (index == 4) {
            // Xs Max
            imageViewWidth.constant = 621
            imageViewHeight.constant = 1344
        } else {
            imageViewWidth.constant = 375
            imageViewHeight.constant = 667
        }
        let sizeStr = "\(imageViewWidth.constant), \(imageViewHeight.constant)"
        imageViewDescLabel.stringValue = sizeStr
    }

}

