//
//  AnimeDetailView.swift
//  AnimeApp
//
//  Created by Марат on 30.08.2023.
//

import UIKit
import SnapKit
import Kingfisher

// MARK: - AnimeDetailViewDelegate
protocol AnimeDetailViewDelegate: AnyObject {
    func playButtonTapped()
    func downloadButtonTapped()
    func shareButtonTapped()
}

// MARK: - AnimeDetailView
// FIXME: - можно переписать на collectionView
final class AnimeDetailView: UIView {
    
    weak var delegate: AnimeDetailViewDelegate?
    
    private let anime: Anime
    
    var characters: Characters? {
        didSet {
            collectionView.reloadData()
            charactersLabel.isHidden = characters == nil || characters?.isEmpty == true
        }
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        return scrollView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.cornerCurve = .continuous
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        return imageView
    }()
    
    // FIXME: - MOCK view
    private let separatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = .brandGray
        return view
    }()
    
    private let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = .brandGray
        return view
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let d1 = DescriptionItemView(icon: .calendar, title: anime.releaseYear ?? "unknown")
        let d2 = DescriptionItemView(icon: .clock, title: anime.duration ?? "unknown")
        let d3 = DescriptionItemView(icon: .film, title: anime.majorGenre ?? "unknown")
        
        let stack = UIStackView(arrangedSubviews: [d1, separatorView1, d2, separatorView2, d3])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 12

        separatorView1.setContentCompressionResistancePriority(.required, for: .horizontal)
        separatorView2.setContentCompressionResistancePriority(.required, for: .horizontal)
        separatorView1.setContentHuggingPriority(.required, for: .horizontal)
        separatorView2.setContentHuggingPriority(.required, for: .horizontal)
        
        return stack
    }()
    
    private lazy var scoreView: ScoreView = {
        let scoreView = ScoreView(score: anime.score)
        return scoreView
    }()
    
    private lazy var playButton: UIButton = {
        var btn: UIButton!
        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = .montserratMedium(size: 16)
                return outgoing
            }
            configuration.title = "Play"
            configuration.image = .play?.template
            configuration.baseBackgroundColor = .brandDarkOrange
            configuration.imagePadding = 8
            
            btn = UIButton(configuration: configuration)
        } else {
            btn = UIButton()
            btn.backgroundColor = .brandBlue
            btn.isOpaque = true
            btn.setImage(.play?.template, for: .normal)
            btn.setTitle("Play", for: .normal)
            btn.tintColor = .white
        }
        
        btn.roundCorners(24)
        btn.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var downloadButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brandBlue
        btn.isOpaque = true
        btn.setImage(.download?.template, for: .normal)
        btn.tintColor = .brandDarkOrange
        btn.roundCorners(24)
        btn.addTarget(self, action: #selector(downloadButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var shareButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brandBlue
        btn.isOpaque = true
        btn.setImage(.share?.template, for: .normal)
        btn.tintColor = .brandLightBlue
        btn.roundCorners(24)
        btn.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        playButton.snp.makeConstraints {
            $0.height.equalTo(48).priority(.required)
            $0.width.equalTo(115).priority(.required)
        }
        downloadButton.snp.makeConstraints { $0.size.equalTo(48).priority(.required) }
        shareButton.snp.makeConstraints { $0.size.equalTo(48).priority(.required) }
        
        let stack = UIStackView(arrangedSubviews: [playButton,
                                                   downloadButton,
                                                   shareButton])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    
    private let synopsisTilteLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .montserratSemiBold(size: 16)
        lbl.text = "Story Line"
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        lbl.setContentHuggingPriority(.required, for: .vertical)
        return lbl
    }()
    
    private lazy var synopsisLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .montserratRegular(size: 14)
        lbl.text = anime.synopsis
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        lbl.setContentHuggingPriority(.required, for: .vertical)
        return lbl
    }()
    
    private let charactersLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .montserratSemiBold(size: 16)
        lbl.text = "Characters"
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        lbl.setContentHuggingPriority(.required, for: .vertical)
        return lbl
    }()
    
    private lazy var synopsisStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [synopsisTilteLabel,
                                                   synopsisLabel,
                                                   charactersLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 8
        stack.setCustomSpacing(24, after: synopsisLabel)
        return stack
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .brandDarkBlue
        collection.isOpaque = true
        
        collection.contentInset = UIEdgeInsets(top: 0,
                                               left: 24,
                                               bottom: 0,
                                               right: 24)
        
        collection.register(CharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    private lazy var stackView: UIStackView = {
        descriptionStackView.snp.makeConstraints { $0.height.equalTo(32) }
        scoreView.snp.makeConstraints { $0.height.equalTo(24) }
        let stack = UIStackView(arrangedSubviews: [posterImageView,
                                                   descriptionStackView,
                                                   scoreView,
                                                   buttonsStackView,
                                                   synopsisStackView])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        
        stack.setCustomSpacing(24, after: posterImageView)
        stack.setCustomSpacing(16, after: descriptionStackView)
        stack.setCustomSpacing(24, after: scoreView)
        stack.setCustomSpacing(24, after: buttonsStackView)
        return stack
    }()
    
    // MARK: - Inits
    init(frame: CGRect, anime: Anime, characters: Characters?) {
        self.anime = anime
        self.characters = characters
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 12, targetSize: CGSize(width: 205, height: 287))
        posterImageView.kf.setImage(with: URL(string: anime.images?.largeImageURL ?? ""),
                                    options: [
                                        .processor(processor),
                                        .scaleFactor(UIScreen.main.scale),
                                        .cacheOriginalImage
                                    ])
        
        print(anime.malID)
    }
    
    convenience init(anime: Anime, characters: Characters? = nil) {
        self.init(frame: .zero, anime: anime, characters: characters)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubviews(stackView, collectionView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints {
            $0.width.equalTo(205).priority(.high)
            $0.height.equalTo(287).priority(.required)
        }
        
        separatorView1.snp.makeConstraints {
            $0.height.equalTo(16).priority(.required)
            $0.width.equalTo(0.66).priority(.low)
        }
        
        separatorView2.snp.makeConstraints {
            $0.height.equalTo(16).priority(.required)
            $0.width.equalTo(0.66).priority(.low)
        }
        
        synopsisStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
            $0.width.equalToSuperview().offset(-48)
            $0.height.equalToSuperview().priority(.low)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(16)
            $0.height.equalTo(60).priority(.required)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: - targets actions
    @objc private func playButtonTapped(_ button: UIButton) {
        delegate?.playButtonTapped()
    }
    
    @objc private func downloadButtonTapped(_ button: UIButton) {
        delegate?.downloadButtonTapped()
    }
    
    @objc private func shareButtonTapped(_ button: UIButton) {
        delegate?.shareButtonTapped()
    }
}

// MARK: - UICollectionViewDataSource
extension AnimeDetailView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier,
                                                            for: indexPath) as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }
        let character = characters?[indexPath.item]
        cell.character = character
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AnimeDetailView: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AnimeDetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 60)
    }
}
