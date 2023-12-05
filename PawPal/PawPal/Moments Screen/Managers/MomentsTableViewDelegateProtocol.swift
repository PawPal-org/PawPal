//
//  MomentsTableViewDelegateProtocol.swift
//  PawPal
//
//  Created by Yitian Guo on 12/5/23.
//

import Foundation

protocol MomentsTableViewCellDelegate: AnyObject {
    func didTapLikeButton(on cell: MomentsTableViewCell)
    func didTapUserImageButton(on cell: MomentsTableViewCell)
    func didTapDeleteButton(on cell: MomentsTableViewCell)
}
