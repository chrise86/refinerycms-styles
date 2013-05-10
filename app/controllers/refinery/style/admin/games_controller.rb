module Refinery
  module Style
    module Admin
      class GamesController < ::Refinery::AdminController
        helper :'refinery/style/admin/dynamic_fields'

        crudify :'refinery/style/game',
                :title_attribute => 'name', :xhr_paging => true

        prepend_before_filter :find_game, :only => [:update, :destroy, :edit, :show, :edit_categories, :analyze]

        def edit_categories
        end

        def analyze
        end
      end
    end
  end
end
