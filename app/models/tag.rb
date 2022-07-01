class Tag < ApplicationRecord
    has_many :event_tags, dependent: :destroy
    has_many :events, through: :event_tags

    validates :phrase, presence: true, uniqueness: { case_sensitive: false }
end
