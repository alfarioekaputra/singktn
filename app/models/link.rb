class Link < ApplicationRecord
    belongs_to :user

    validates :title, presence: true
    validates :url, presence: true

    has_one_attached :thumbnail do |attachable|
        attachable.variant :thumb, resize: "100x100"
    end
end
