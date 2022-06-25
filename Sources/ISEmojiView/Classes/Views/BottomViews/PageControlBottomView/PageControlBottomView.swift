//
//  PageControlBottomView.swift
//  ISEmojiView
//
//  Created by Beniamin Sarkisyan on 01/08/2018.
//

import Foundation
import UIKit

internal protocol PageControlBottomViewDelegate: AnyObject {
    
    func pageControlBottomViewDidPressDeleteBackwardButton(_ bottomView: PageControlBottomView)
    func pageControlBottomViewDidPressDismissKeyboardButton(_ bottomView: PageControlBottomView)
    func pageControlBottomViewPageDidChange(to index: Int, _ bottomView: PageControlBottomView)
    
}

final internal class PageControlBottomView: UIView {
    
    // MARK: - Internal variables
    
    internal weak var delegate: PageControlBottomViewDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var pageControl: UIPageControl!
    
    // MARK: - Init functions
    
    static func loadFromNib(categoriesCount: Int) -> PageControlBottomView {
        let nibName = String(describing: PageControlBottomView.self)
        
        guard let nib = Bundle.podBundle.loadNibNamed(nibName, owner: nil, options: nil) as? [PageControlBottomView] else {
            fatalError()
        }
        
        guard let bottomView = nib.first else {
            fatalError()
        }
        
        bottomView.pageControl.numberOfPages = categoriesCount
        if #available(iOS 14.0, *) {
            bottomView.pageControl.allowsContinuousInteraction = true
        }
        bottomView.pageControl.addTarget(self, action: #selector(pageControlValueDidChange), for: .valueChanged)
        return bottomView
    }
    
    // MARK: - Internal functions
    
    internal func updatePageControlPage(_ page: Int) {
        if #available(iOS 14.0, *) {
            if pageControl.interactionState == .none {
                pageControl.currentPage = page
            }
        } else {
            pageControl.currentPage = page
        }
    }
    
    // MARK: - IBActions
    
    @objc private func pageControlValueDidChange() {
        delegate?.pageControlBottomViewPageDidChange(to: pageControl.currentPage, self)
    }
    
    @IBAction private func deleteBackward() {
        delegate?.pageControlBottomViewDidPressDeleteBackwardButton(self)
    }
    
    @IBAction private func dismissKeyboard() {
        delegate?.pageControlBottomViewDidPressDismissKeyboardButton(self)
    }
    
}
