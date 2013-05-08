module Refinery
  module Style
    module Admin
      class ImageCategoriesController < ::Refinery::AdminController
        helper :'refinery/style/admin/dynamic_fields'

        crudify :'refinery/style/image_category', 
                :class_name => '@scope',
                :title_attribute => 'name', 
                :xhr_paging => true,
                :sortable => false

        prepend_before_filter :find_scope

        def find_scope
          @game = Game.find(params[:game_id]) if params[:game_id]
          @scope = @game.image_categories if @game
          @scope ||= ImageCategory
        end
      end
    end
  end
end
