class Event < ApplicationRecord
    has_many :registrations, dependent: :destroy
    has_many :users, through: :registrations
    has_many :event_tags, dependent: :destroy
    has_many :tags, through: :event_tags
    has_one_attached :image

    validate :reg_start_is_valid_datetime,
    :reg_end_is_valid_datetime
    enum :category, { Coding: 0, Bootcamp: 1, Webinar: 2, Workshop: 3 }
    validates :category, inclusion: { in: categories.keys }
    validates :title, presence: true
    validates :description, presence: true
    validates :venue, format: {with: /[a-zA-Z]/}
    validates :fees, numericality: {only_float: true}    

    def reg_start_is_valid_datetime
        errors.add(:reg_start, 'must be a valid datetime') if ((DateTime.parse(reg_start.to_s) rescue ArgumentError) == ArgumentError)
    end
    def reg_end_is_valid_datetime
        errors.add(:reg_end, 'must be a valid datetime') if ((DateTime.parse(reg_end.to_s) rescue ArgumentError) == ArgumentError)
    end
end
