class Job < ApplicationRecord
  has_many :commands
  belongs_to :app
end
