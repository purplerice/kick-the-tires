class City < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings

  attr_accessible :latitude, :longitude, :name, :tag_names
  #attr_accessor :tag_names
  attr_writer :tag_names

  geocoded_by :name

  after_save :assign_tags
  after_validation :geocode, :if => :name_changed?

  validates :name, presence: true

  default_scope order: 'cities.name ASC'

  def tag_names
    @tag_names || tags.map(&:name).join(' ')
  end

  #def self.search(search)
  #  search = search.downcase
  #  if search
  #    joins(:tags).where('LOWER (cities.name) LIKE ? OR LOWER (tags.name) LIKE ?', "%#{search}%", "%#{search}%")
  #  else
  #    find(:all)
  #  end
  #end

  def self.search(search)
    search = search.downcase
    if search
      joins(:tags).where('(LOWER (cities.name) LIKE ? OR LOWER (tags.name) LIKE ?) OR (LOWER (cities.name) LIKE ?)', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      find(:all)
    end
  end



  #class < self
    def self.search2(search)
      joins(:tags).
          where(<<-SQL, :name => search)
             (tags.name  = :name OR
             cities.name = :name) AND
            (cities.name = :name)
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
