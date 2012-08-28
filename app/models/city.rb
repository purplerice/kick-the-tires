class City < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings

  attr_accessible :latitude, :longitude, :name, :tag_names
  attr_writer :tag_names

  geocoded_by :name

  after_save :assign_tags
  after_validation :geocode, :if => :name_changed?

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false

  default_scope order: 'cities.name ASC'

  def tag_names
    @tag_names || tags.map(&:name).join(' ')
  end

  def self.search(search,by_what)
    search = search.strip.squeeze(" ").downcase
    if search
      if by_what=='tag'
        joins(:tags).where('LOWER(cities.name) LIKE LOWER(?) OR LOWER(tags.name) LIKE LOWER(?)', "%#{search.downcase}%", "%#{search.downcase}%")
      else
        where('LOWER(cities.name) LIKE LOWER(?)', "%#{search.downcase}%")
      end

    else
      find(:all)
    end
  end





  #class < self
    def self.search2(search)
      joins(:tags).
          where(<<-SQL, :name => search)
            (cities.name = :name) OR
             (tags.name  = :name OR
             cities.name = :name)
      SQL
    end
  #end



  private
  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/\s+/).map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end
end
