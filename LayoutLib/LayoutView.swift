//
//  LayoutView.swift
//  LayoutLib
//
//  Created by Dima Gubatenko on 08.07.17.
//
//

import UIKit

@objc
public protocol LayoutViewDelegate : class {
    @objc
    optional func LVDwillAdd(subview: UIView, in layoutView: LayoutView)

    @objc
    optional func LVDdidAdd(subview: UIView, in layoutView: LayoutView)

    @objc
    optional func LVDwillInsert(subview: UIView, in layoutView: LayoutView, at index: Int)

    @objc
    optional func LVDdidInsert(subview: UIView, in layoutView: LayoutView, at index: Int)

    @objc
    optional func LVDwillRemoveAllSubviews(in layoutView: LayoutView)

    @objc
    optional func LVDdidRemoveAllSubviews(in layoutView: LayoutView)

    @objc
    optional func LVDwillRemoveSubview(at index: Int, in layoutView: LayoutView)

    @objc
    optional func LVDdidRemoveSubview(at index: Int, in layoutView: LayoutView)

    @objc
    optional func LVDwillLayoutSubviews()

    @objc
    optional func LVDdidLayoutSubviews()

    @objc
    optional func LVDwillLayout(view: UIView, in layoutView: LayoutView)

    @objc
    optional func LVDerrorWhenLayout(_ error: LayoutView.Errors, view: UIView, in layoutView: LayoutView)

    @objc
    optional func LVDdidLayout(view: UIView, in layoutView: LayoutView)
}

open class LayoutView: UIView {

    open private(set) var views = [UIView]()
    public struct Global {
        public fileprivate(set) static var x: CGFloat = 0
        public fileprivate(set) static var y: CGFloat = 0
    }

    open weak var delegate: LayoutViewDelegate?

    open var viewInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    @objc
    public enum Errors : Int, Error {
        case noEmptyVerticalSpace
        case viewNotFullVisibleHorisontal
        case viewNotFullVisibleVertical
    }

    override open func addSubview(_ view: UIView) {
        delegate?.LVDwillAdd?(subview: view, in: self)
        views.append(view)
        super.addSubview(view)
        delegate?.LVDdidAdd?(subview: view, in: self)
    }

    override open func insertSubview(_ view: UIView, at index: Int) {
        precondition(index < views.count, "index \(index) must be < \(views.count)")
        delegate?.LVDwillInsert?(subview: view, in: self, at: index)
        views.insert(view, at: index)
        super.addSubview(view)
        delegate?.LVDdidInsert?(subview: view, in: self, at: index)
    }

    open func removeAllSubviews() {
        delegate?.LVDwillRemoveAllSubviews?(in: self)
        views.forEach { $0.removeFromSuperview() }
        views.removeAll()
        setNeedsLayout()
        delegate?.LVDdidRemoveAllSubviews?(in: self)
    }

    open func removeSubview(at index: Int) {
        precondition(index < views.count, "index \(index) must be < \(views.count)")
        delegate?.LVDwillRemoveSubview?(at: index, in: self)
        views[index].removeFromSuperview()
        views.remove(at: index)
        setNeedsLayout()
        delegate?.LVDdidRemoveSubview?(at: index, in: self)
    }

    override open func layoutSubviews() {
        guard !views.isEmpty else { return }
        delegate?.LVDwillLayoutSubviews?()
        Global.x = 0
        Global.y = viewInset.top
        for view in views {
            guard Global.y < self.bounds.height else {
                view.isHidden = true
                continue
            }
            view.isHidden = false
            delegate?.LVDwillLayout?(view: view, in: self)
            Global.x += viewInset.left
            if view.frame.width > self.bounds.width || Global.x + view.frame.width > self.bounds.width {
                delegate?.LVDerrorWhenLayout?(.viewNotFullVisibleHorisontal, view: view, in: self)
            }
            if view.frame.height > self.bounds.height || Global.y + view.frame.height > self.bounds.height {
                delegate?.LVDerrorWhenLayout?(.viewNotFullVisibleVertical, view: view, in: self)
            }
            view.frame.origin = CGPoint(x: Global.x, y: Global.y)
            Global.x += view.frame.width + viewInset.right
            if Global.x > self.bounds.width {
                Global.x = 0
                Global.y += view.frame.height + viewInset.bottom + viewInset.top
            }
            delegate?.LVDdidLayout?(view: view, in: self)
            if Global.y > self.bounds.height {
                delegate?.LVDerrorWhenLayout?(.noEmptyVerticalSpace, view: view, in: self)
            }
        }
        delegate?.LVDdidLayoutSubviews?()
    }
}
