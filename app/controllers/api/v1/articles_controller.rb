module Api
    module V1
        class ArticlesController < ApplicationController
            include ActionController::HttpAuthentication::Basic::ControllerMethods
            # http_basic_authenticate_with name: "admin", password: "test"
            before_action :restrict_access

            def index
                articles = Article.order('created_at DESC');
                render json: {status: 'SUCCESS', message: 'Loaded articles', data: articles},status: :ok
            end

            def show
                article = Article.find( params[:id] )
                render json: {status: 'SUCCESS', message: 'Loaded articles', data: article},status: :ok
            end

            def create
                article = Article.new( article_params )
                if article.save
                    render json: {status: 'SUCCESS', message: 'Saved article', data: article},status: :ok
                else
                    render json: {status: 'ERROR', message: 'Article not saved', data: article.errors},status: :unprocessable_entity
                end
            end

            def destroy
                article = Article.find( params[:id] )
                article.destroy
                render json: {status: 'SUCCESS', message: 'Deleted articles', data: article},status: :ok
            end

            def update
                article = Article.find( params[:id] )
                if article.update_attributes(article_params)
                    render json: {status: 'SUCCESS', message: 'Updated article', data: article},status: :ok
                else
                    render json: {status: 'ERROR', message: 'Article not updated', data: article.errors},status: :unprocessable_entity
                end
            end

            private
            def article_params
                params.permit(:title, :body)
            end

            def restrict_access
                api_key = ApiKey.find_by_access_token(params[:access_token]);
                head :unauthorized unless api_key
            end

        end
    end
end