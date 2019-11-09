class AddAttributesToStudentsAndEmployees < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      ALTER TABLE students
        ADD middle_name varchar,
        ADD ticket_number varchar UNIQUE,
        ADD passport_number varchar UNIQUE,
        ADD inn varchar UNIQUE,
        ADD phone_number varchar,
        ADD email varchar;
    SQL

    execute <<-SQL
      ALTER TABLE employees
        ADD middle_name varchar,
        ADD passport_number varchar UNIQUE,
        ADD inn varchar UNIQUE,
        ADD phone_number varchar,
        ADD email varchar;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE employees
        DROP middle_name,
        DROP passport_number,
        DROP inn,
        DROP phone_number,
        DROP email;
    SQL

    execute <<-SQL
      ALTER TABLE students
        DROP middle_name,
        DROP ticket_number,
        DROP passport_number,
        DROP inn,
        DROP phone_number,
        DROP email;
    SQL
  end
end
