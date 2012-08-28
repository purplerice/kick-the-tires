class Tagging < ActiveRecord::Base
  #attr_accessible :city_id, :tag_id
  belongs_to :city
  belongs_to :tag
end

