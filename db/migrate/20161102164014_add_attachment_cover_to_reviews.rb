class AddAttachmentCoverToReviews < ActiveRecord::Migration
  def self.up
    change_table :reviews do |t|
      t.attachment :cover
    end
  end

  def self.down
    remove_attachment :reviews, :cover
  end
end
