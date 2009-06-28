class UploadedImage < Upload
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :size => 0...(5.megabytes),
                 :resize_to => '1024x768>',
                 :thumbnails => { :thumb => '80x80>' }

  validates_as_attachment
end