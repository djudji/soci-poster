class AddFacebookPageToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :facebook_page, :boolean
  end
end
