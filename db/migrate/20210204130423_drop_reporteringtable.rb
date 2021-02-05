class DropReporteringtable < ActiveRecord::Migration[6.0]
  def change
    drop_table :reporting_uesr_feedbacks
  end
end
