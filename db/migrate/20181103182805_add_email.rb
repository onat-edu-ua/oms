class AddEmail < ActiveRecord::Migration[5.2]
  def up
    execute %q{
      create table domains(
        id serial primary key,
        fqdn varchar not null unique,
        created_at timestamptz,
        updated_at timestamptz
      );

      create table email_redirects(
        id serial primary key,
        username varchar not null,
        domain_id integer not null references domains(id),
        rewrited_destination varchar not null,
        created_at timestamptz,
        updated_at timestamptz
      );
      create unique index on email_redirects using btree(username, domain_id);
    }
  end

  def down
    execute %q{
      drop table email_redirects;
      drop table domains;
    }
  end

end
