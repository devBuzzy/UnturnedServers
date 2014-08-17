# encoding: utf-8

class BannerUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :grid_fs

  process :resize_to_fit => [468, 60]

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
