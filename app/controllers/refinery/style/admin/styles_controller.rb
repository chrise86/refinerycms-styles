module Refinery
  module Style
    module Admin
      class StylesController < ::Refinery::AdminController

        crudify :'refinery/style/style',
                :title_attribute => 'name', :xhr_paging => true

      end
    end
  end
end
