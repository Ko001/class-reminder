class AddUserIdToCourseTime < ActiveRecord::Migration[6.0]
  def change
    add_column :course_times, :user_id, :integer
  end
end
