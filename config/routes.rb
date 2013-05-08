Refinery::Core::Engine.routes.append do

  # Frontend routes
  namespace :style do
    resources :games, :only => [:index, :show] do
      member do
        post :choice
      end
    end
  end

  # Admin routes
  namespace :style, :path => '' do
    namespace :admin, :path => 'refinery/style' do
      resources :games, :except => :show do
        collection do
          post :update_positions
        end

        member do
          get :edit_categories
          get :analyze
        end

        # resources :image_categories, :except => :show do
        #   collection do
        #     post :update_positions
        #   end
        # end
      end

      # resources :image_categories, :except => :show
      # resources :images, :except => :show

    end
  end

end
