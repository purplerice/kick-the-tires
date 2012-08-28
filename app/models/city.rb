class City < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :name
  geocoded_by :name
  after_validation :geocode, :if => :name_changed?
  validates :name, presence: true

  scope :first_ten, :limit => "5"

  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end
end
