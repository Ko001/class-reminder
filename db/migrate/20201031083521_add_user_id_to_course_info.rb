class AddUserIdToCourseInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :course_infos, :user_id, :integer
  end
end
