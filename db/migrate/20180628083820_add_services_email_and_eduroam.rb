class AddServicesEmailAndEduroam < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      INSERT INTO public.services (id, name, created_at, updated_at) VALUES
      (1, 'Email', now(), now()),
      (2, 'Eduroam', now(), now());
    SQL
  end
end
