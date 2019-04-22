# frozen_string_literal: true

class CreatePackages < ActiveRecord::Migration[5.2]
  def change
    create_table :packages do |t|
      t.string :name
      t.text :description
      t.string :title
      t.string :authors
      t.string :version
      t.string :maintainers
      t.string :license
      t.datetime :publication_date

      t.timestamps
    end
  end
end
