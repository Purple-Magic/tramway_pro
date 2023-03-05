at = Time.now.strftime('%Y-%m-%d--%H-%M')
dump = "tramway_pro--#{at}.dump"
db_name = Rails.configuration.database_configuration['production']['database']
system "ssh -t 'docker-compose exec db pg_dump -Fc --no-acl --no-owner -v #{db_name} > /dumps/#{dump}'"
