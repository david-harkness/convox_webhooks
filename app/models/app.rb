class App < ApplicationRecord
  belongs_to :platform

  validates :branch, uniqueness: true,  presence: true, length: {minimum: 4}
  validates :name, uniqueness: true, length: {minimum: 4, maximum: 30}, allow_blank: true
  before_validation:set_name

  private
  def set_name
    self.name = branch.scan(/\w|-/).join[0,30]
  end
end
