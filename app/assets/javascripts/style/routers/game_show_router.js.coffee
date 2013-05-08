class Style.Routers.GameShow extends Backbone.Router
  routes:
    '.*': 'index'

  initialize: (options) ->
    @collection = new Style.Collections.ImageCategories(options)

  index: ->
    view = new Style.Views.GamesShow(collection: @collection)
    $('#container').html(view.render().el)
