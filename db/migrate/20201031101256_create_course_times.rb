class CreateCourseTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :course_times do |t|
      t.integer :class_num
      t.time :start
      t.time :end

      t.timestamps
    end
  end
end
