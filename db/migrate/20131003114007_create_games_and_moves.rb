class CreateGamesAndMoves < ActiveRecord::Migration
  def up
    create_table :games do |t|
      t.text :squares, null: false, default: [].to_yaml
      t.timestamps
    end

    create_table :moves do |t|
      t.integer :coordinate, null: false
      t.references :game, null: false
      t.timestamps
    end
  end

  def down
    drop_table :moves
    drop_table :games
  end
end
