//  SlideInTransition.swift
//  YoutubeViewController
//
//  Created by Lydia Lu on 2024/4/29.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {


    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3 // 过渡动画持续时间
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        // 设置初始位置在屏幕左侧外面
        toView.frame.origin.x = -containerView.bounds.width * 3 / 4
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            // 将视图移到屏幕左侧外面到覆盖屏幕的3/4位置
            toView.frame.origin.x = 0
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
