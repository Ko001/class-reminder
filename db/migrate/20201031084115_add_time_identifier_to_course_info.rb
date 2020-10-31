class AddTimeIdentifierToCourseInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :course_infos, :day, :integer
    add_column :course_infos, :time, :integer
  end
end
