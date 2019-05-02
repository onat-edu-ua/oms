PunditRoles.configure do |config|
  roles_config_path = Rails.root.join('config', 'policy_roles.yml')
  config.roles_config = YAML.load_file(roles_config_path).deep_symbolize_keys
end
