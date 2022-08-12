//
//  Drops
//
//  Copyright (c) 2021-Present Omar Albeik - https://github.com/omaralbeik
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

internal final class DropView: UIView {
  required init(drop: Drop) {
    self.drop = drop
    super.init(frame: .zero)
      
    backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)

    addSubview(stackView)
      
    let constraints = createLayoutConstraints(for: drop)
    NSLayoutConstraint.activate(constraints)
    configureViews(for: drop)
  }

  required init?(coder _: NSCoder) {
    return nil
  }

  override var frame: CGRect {
    didSet { layer.cornerRadius = frame.cornerRadius }
  }

  override var bounds: CGRect {
    didSet { layer.cornerRadius = frame.cornerRadius }
  }

  let drop: Drop

  func createLayoutConstraints(for drop: Drop) -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []

    constraints += [
      imageView.heightAnchor.constraint(equalToConstant: 24),
      imageView.widthAnchor.constraint(equalToConstant: 24)
    ]

    constraints += [
      button.heightAnchor.constraint(equalToConstant: 35),
      button.widthAnchor.constraint(equalToConstant: 35)
    ]
      
    var insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    if UIDevice.isiPad() {
        insets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
    }

    constraints += [
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
      stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: insets.top),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
    ]

    return constraints
  }

  func configureViews(for drop: Drop) {
    clipsToBounds = true

    titleLabel.text = drop.title
    titleLabel.numberOfLines = drop.titleNumberOfLines

    subtitleLabel.text = drop.subtitle
    subtitleLabel.numberOfLines = drop.subtitleNumberOfLines
    subtitleLabel.isHidden = drop.subtitle == nil

    imageView.image = drop.icon
    imageView.isHidden = drop.icon == nil
    imageView.tintColor = .white

    button.setImage(drop.action?.icon, for: .normal)
    button.isHidden = drop.action?.icon == nil

    if let action = drop.action, action.icon == nil {
      let tap = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
      addGestureRecognizer(tap)
    }

    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 18
    layer.shadowOpacity = 0.3
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    layer.masksToBounds = false
  }

  @objc
  func didTapButton() {
    drop.action?.handler()
  }

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .left
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    label.adjustsFontForContentSizeCategory = true
    label.adjustsFontSizeToFitWidth = true
    return label
  }()

  lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .left
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 15, weight: .light)
    label.adjustsFontForContentSizeCategory = true
    label.adjustsFontSizeToFitWidth = true
    return label
  }()

  lazy var imageView: UIImageView = {
    let view = RoundImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.clipsToBounds = true
    view.tintColor = UIAccessibility.isDarkerSystemColorsEnabled ? .label : .secondaryLabel
    return view
  }()

  lazy var button: UIButton = {
    let button = RoundButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    button.clipsToBounds = true
    button.backgroundColor = .link
    button.tintColor = .white
    button.imageView?.contentMode = .scaleAspectFit
    button.contentEdgeInsets = .init(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
    return button
  }()

  lazy var labelsStackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.alignment = .fill
    view.distribution = .fill
    view.spacing = 2
    return view
  }()

  lazy var stackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [imageView, labelsStackView, button])
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.alignment = .center
    view.distribution = .fill
    if drop.icon != nil, drop.action?.icon != nil {
      view.spacing = 16
    } else {
      view.spacing = 16
    }
    return view
  }()
}

final class RoundButton: UIButton {
  override var bounds: CGRect {
    didSet { layer.cornerRadius = frame.cornerRadius }
  }
}

final class RoundImageView: UIImageView {
  override var bounds: CGRect {
    didSet { layer.cornerRadius = frame.cornerRadius }
  }
}

extension CGRect {
  var cornerRadius: CGFloat {
    return 13
  }
}
