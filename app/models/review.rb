class Review < ActiveRecord::Base
	
	has_attached_file :cover, styles: { medium: "300x300>", hmedium: "450x450>", thumb: "100x100>", wide: "1900x450#" },	
	:path => ":rails_root/public/system/:attachment/:id/:style/:filename",    
	:url => "/system/:attachment/:id/:style/:filename"
	validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/
	validates :title, :presence => true, :uniqueness => true, :length => { :in => 3..800 }, on: :create
	validates :short_description, :presence => true, :uniqueness => true, :length => { :in => 3..1000 }, on: :create
	validates :long_description, :presence => true, :uniqueness => true, :length => { :in => 3..99999 }, on: :create
	validates :keywords, :presence => true, :uniqueness => true, :length => { :in => 3..1500 }, on: :create
	
end
