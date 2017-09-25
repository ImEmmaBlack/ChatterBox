class AddTrigramsModel < ActiveRecord::Migration[5.1]
  extend Fuzzily::Migration
  trigrams_owner_id_column_type = :uuid
end
