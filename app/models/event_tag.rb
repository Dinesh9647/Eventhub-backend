class EventTag < ApplicationRecord
  belongs_to :event
  belongs_to :tag

  validates_uniqueness_of :event_id, :scope => :tag_id
end
