class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
#, :lockable, :timeoutable and :omniauthable   
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  enum role: [:user, :vip, :admin]
  #user = student
  #vip = Professor
  #admin = admin
  after_initialize :set_default_role, :if => :new_record?


  def set_default_role
    self.role ||= :user
  end


##FOR IMAGE UPLOADING
has_attached_file :avatar, 
:path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
:url => "/system/:attachment/:id/:basename_:style.:extension",
default_url: '/assets/missing_avatar.jpg',
:styles => {
  :thumb    => ['100x100#',  :jpg, :quality => 70],
  :preview  => ['480x480#',  :jpg, :quality => 70],
  :large    => ['600>',      :jpg, :quality => 70],
  :retina   => ['1200>',     :jpg, :quality => 30]
},
:convert_options => {
  :thumb    => '-set colorspace sRGB -strip',
  :preview  => '-set colorspace sRGB -strip',
  :large    => '-set colorspace sRGB -strip',
  :retina   => '-set colorspace sRGB -strip -sharpen 0x0.5'
}
##VALIDATE UPLOAD IS AN IMAGE
validates_attachment :avatar,
    #:presence => false,
    :size => { :in => 0..8.megabytes },
    :content_type => { :content_type => /^image\/(jpeg|png|gif|tiff)$/ }
end
