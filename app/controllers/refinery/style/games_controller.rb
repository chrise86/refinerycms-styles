module Refinery
  module Style
    class GamesController < ::ApplicationController

      before_filter :find_all_games
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @game in the line below:
        present(@page)
      end

      def show
        @game = Game.find(params[:id])

        @categories = @game.sample_categories

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @game in the line below:
        present(@page)

        render :layout => 'refinery/iframe' if params[:iframe]
      end

    def choice
      @game = Game.find(params[:id])
      @images = Image.find_all_by_id(params[:choices])
      @style = @game.make_choice(@images)
      @game.trace env, params[:choices], @style.id
       
      respond_to do |format|
        format.json { render json: @style.to_json }
      end
    end
    
    protected

      def find_all_games
        @games = Game.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/games").first
      end

    end
  end
end
