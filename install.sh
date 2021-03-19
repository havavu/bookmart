#cp bookmart /etc/nginx/sites-available/bookmart
#ln -s /etc/nginx/sites-available/bookmart /etc/nginx/sites-enabled/bookmart
git clone -b deplop https://github.com/violeine/bookmart-frontend
cd bookmart-frontend && \
	sed -i 's/http\:\/\/violeine.freemyip.com\:8080\/graphql/https\:\/\/be.bookmart.duckdns.org\/graphql/g' src/vue-apollo.js && \
	yarn install && \
	yarn build && \
	cd ..
git clone -b report https://github.com/anhvuk13/bookmart-backend
rm -rf bookmart-backend/resources/views/vendor
rm -rf bookmart-backend/config/graphql*
docker-compose down 2> /dev/null
docker-compose up -d && \
	docker exec -it bookmart_server composer install && \
	docker exec -it bookmart_server php artisan vendor:publish --tag=graphql-playground-config && \
	docker exec -it bookmart_server php artisan vendor:publish --tag=graphql-playground-view && \
	docker exec -it bookmart_server php artisan config:cache
  docker exec -it bookmart_server sed -i "s/{{url(config('graphql-playground\.endpoint'))}}/https:\/\/be\.bookmart\.duckdns\.org\/graphql/g" resources/views/vendor/graphql-playground/index.blade.php
  docker exec -it bookmart_server sed -i "s/{{config('graphql-playground\.subscriptionEndpoint')}}/https:\/\/be\.bookmart\.duckdns\.org\/graphql/g" resources/views/vendor/graphql-playground/index.blade.php
sudo chown www-data:www-data . -R
