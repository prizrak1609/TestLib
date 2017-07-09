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

public protocol LayoutViewDelegateInfo : class {
    func LVDupdate(info: LayoutView.Info, in layoutView: LayoutView)
}

open class LayoutView: UIView {

    public struct Info {
        public var nextX: CGFloat = 0
        public var nextY: CGFloat = 0
        public var estimatedSize = CGSize.zero
    }

    open private(set) var views = ContiguousArray<UIView>()
    open private(set) var info = Info(nextX: 0, nextY: 0, estimatedSize: .zero)

    open weak var delegate: (LayoutViewDelegate & LayoutViewDelegateInfo)?

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
        info.nextX = 0
        info.nextY = viewInset.top
        for view in views {
            let currentEstimatedHeight = info.nextY + view.frame.height + viewInset.bottom
            if currentEstimatedHeight > info.estimatedSize.height {
                info.estimatedSize.height = currentEstimatedHeight
            }
            let currentEstimatedWidth = info.nextX + viewInset.left + view.frame.width + viewInset.right
            if currentEstimatedWidth > info.estimatedSize.width {
                info.estimatedSize.width = currentEstimatedWidth
            }
            delegate?.LVDupdate(info: info, in: self)
            guard info.nextY < self.bounds.height else {
                view.isHidden = true
                continue
            }
            view.isHidden = false
            delegate?.LVDwillLayout?(view: view, in: self)
            info.nextX += viewInset.left
            if view.frame.width > self.bounds.width || info.nextX + view.frame.width > self.bounds.width {
                delegate?.LVDerrorWhenLayout?(.viewNotFullVisibleHorisontal, view: view, in: self)
            }
            if view.frame.height > self.bounds.height || info.nextY + view.frame.height > self.bounds.height {
                delegate?.LVDerrorWhenLayout?(.viewNotFullVisibleVertical, view: view, in: self)
            }
            view.frame.origin = CGPoint(x: info.nextX, y: info.nextY)
            info.nextX += view.frame.width + viewInset.right
            if info.nextX > self.bounds.width {
                info.nextX = 0
                info.nextY += view.frame.height + viewInset.bottom + viewInset.top
            }
            delegate?.LVDdidLayout?(view: view, in: self)
            if info.nextY > self.bounds.height {
                delegate?.LVDerrorWhenLayout?(.noEmptyVerticalSpace, view: view, in: self)
            }
        }
        delegate?.LVDdidLayoutSubviews?()
    }
}
