ActiveRecord::Schema.define(version: 0) do
  create_table :books do |t|
    t.string :title
    t.string :author
    t.integer :page
  end
end
