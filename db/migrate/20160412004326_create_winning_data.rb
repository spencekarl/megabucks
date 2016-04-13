class CreateWinningData < ActiveRecord::Migration
  def change
    create_table :winning_data do |t|

      t.timestamps null: false
    end
  end
end
