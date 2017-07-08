//
//  ViewController.swift
//  LayoutLib
//
//  Created by Dima Gubatenko on 08.07.17.
//
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet fileprivate weak var containerView: LayoutView! {
        didSet {
            containerView.delegate = self
        }
    }

    fileprivate var viewNumber = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerView.viewInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning")
    }

    @IBAction func addFirst(_ sender: UIButton) {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        view.text = "Test \(viewNumber)"
        viewNumber += 1
        containerView.insertSubview(view, at: 0)
    }

    @IBAction func addRandom(_ sender: UIButton) {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        view.text = "Test \(viewNumber)"
        viewNumber += 1
        let index = Int(arc4random_uniform(UInt32(containerView.views.count)))
        containerView.insertSubview(view, at: index)
    }

    @IBAction func addLast(_ sender: UIButton) {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        view.text = "Test \(viewNumber)"
        viewNumber += 1
        containerView.addSubview(view)
    }

    @IBAction func removeFirst(_ sender: UIButton) {
        containerView.removeSubview(at: 0)
    }

    @IBAction func removeRandom(_ sender: UIButton) {
        let index = Int(arc4random_uniform(UInt32(containerView.views.count)))
        containerView.removeSubview(at: index)
    }

    @IBAction func removeLast(_ sender: UIButton) {
        containerView.removeSubview(at: containerView.views.count - 1)
    }

    @IBAction func removeAll(_ sender: UIButton) {
        containerView.removeAllSubviews()
    }
}

extension ViewController : LayoutViewDelegate {

    func LVDwillAdd(subview: UIView, in layoutView: LayoutView) {
        print(#function, subview, "in", layoutView)
    }

    func LVDdidAdd(subview: UIView, in layoutView: LayoutView) {
        print(#function, subview, "in", layoutView)
    }

    func LVDwillInsert(subview: UIView, in layoutView: LayoutView, at index: Int) {
        print(#function, subview, "in", layoutView, "at", index)
    }

    func LVDdidInsert(subview: UIView, in layoutView: LayoutView, at index: Int) {
        print(#function, subview, "in", layoutView, "at", index)
    }

    func LVDwillRemoveAllSubviews(in layoutView: LayoutView) {
        print(#function, "in", layoutView)
    }

    func LVDdidRemoveAllSubviews(in layoutView: LayoutView) {
        print(#function, "in", layoutView)
    }

    func LVDwillRemoveSubview(at index: Int, in layoutView: LayoutView) {
        print(#function, "at", index, "in", layoutView)
    }

    func LVDdidRemoveSubview(at index: Int, in layoutView: LayoutView) {
        print(#function, "at", index, "in", layoutView)
    }

    func LVDwillLayoutSubviews() {
        print(#function)
    }

    func LVDdidLayoutSubviews() {
        print(#function)
    }

    func LVDwillLayout(view: UIView, in layoutView: LayoutView) {
        print(#function, view, "in", layoutView)
    }

    func LVDerrorWhenLayout(_ error: LayoutView.Errors, view: UIView, in layoutView: LayoutView) {
        print(#function, error.rawValue, "view", view, "in", layoutView)
    }

    func LVDdidLayout(view: UIView, in layoutView: LayoutView) {
        print(#function, view, "in", layoutView)
    }
}
