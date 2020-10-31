class CreateCourseInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :course_infos do |t|
      t.string :course
      t.string :prof
      t.text :location
      t.string :pass

      t.timestamps
    end
  end
end
