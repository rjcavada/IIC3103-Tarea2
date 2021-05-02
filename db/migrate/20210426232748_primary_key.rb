class PrimaryKey < ActiveRecord::Migration[5.2]
  def change
    execute "ALTER TABLE artists ADD PRIMARY KEY (id);"
    execute "ALTER TABLE albums ADD PRIMARY KEY (id);"
    execute "ALTER TABLE tracks ADD PRIMARY KEY (id);"
  end
end
