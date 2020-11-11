class CreateCourseTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :course_times do |t|
      t.integer :class_num
      t.integer :start_hour
      t.integer :start_minute
      t.integer :end_hour
      t.integer :end_minute
      t.timestamps
    end
  end
end
