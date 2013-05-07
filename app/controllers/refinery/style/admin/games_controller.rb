module Refinery
  module Style
    module Admin
      class GamesController < ::Refinery::AdminController
        helper :'refinery/style/admin/dynamic_fields'

        crudify :'refinery/style/game',
                :title_attribute => 'name', :xhr_paging => true


      end
    end
  end
end
