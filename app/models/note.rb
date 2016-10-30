class Note < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :folder
end
