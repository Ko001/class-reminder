class SetHourAndMinuteOnClassTime2 < ActiveRecord::Migration[6.0]
  def change
    remove_column :course_times, :start_time
    remove_column :course_times, :end_time
    add_column :course_times, :start_hour, :integer
    add_column :course_times, :start_minute, :integer
    add_column :course_times, :end_hour, :integer
    add_column :course_times, :end_minute, :integer
  end
end
