class Plot < ApplicationRecord
  belongs_to :user
  has_many :tagmaps, dependent: :destroy
  has_many :tags, through: :tagmaps

  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:tag_name)unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.plot_tags.delete PlotTag.find_by(tag_name: old)
    end
    new_tags.each do |new|
      new_plot_tag = Tag.find_or_create_by(tag_name: new)
      # tagmap = Tag.find_or_create_by(name: new)
      # self.plot.tags << new_plot_tag
      self.tags << new_plot_tag
    end
  end

  def search
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @plots = @tag.posts.all
  end
end
