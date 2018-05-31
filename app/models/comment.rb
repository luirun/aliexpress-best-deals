class Comment < ApplicationRecord
  has_attached_file :image, styles: {medium: "300x300>", hmedium: "450x450>", thumb: "100x100>", wide: "1900x450#"},
                            path: ":rails_root/public/system/:attachment/:id/:style/:filename",
                            url: "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  before_save :select_who_commented

  def select_who_commented
    if current_user.nil?
      @comment.accepted = "n"
      @comment.author = "4"
    else
      @comment.author = current_user.id
      @comment.accepted = "y"
    end
  end

  def self.approve_comments(comments)
    params[:commentId].each do |comment|
      if comment[1][(comment[1].length) - 1] == "a"
        comment[1][(comment[1].length) - 1] = ""
        accept = Comment.find(comment[1])
        accept.accepted = "y"
        accept.save
      end
    end
  end

  def self.delete_comments(comments = nil)
    params[:commentId].each do |comment|
      if comment[1][(comment[1].length) - 1] == "d"
        comment[1][(comment[1].length) - 1] = ""
        deleted = Comment.find(comment[1])
        deleted.delete
      end
    end
  end
end
