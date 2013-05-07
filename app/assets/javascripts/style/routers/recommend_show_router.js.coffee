class Style.Routers.RecommendShow extends Backbone.Router
  routes:
    'recommends': 'index'
    '.*': 'index'

  initialize: (options) ->
    @collection = new Style.Collections.ImageCategories(options)

  index: ->
    view = new Style.Views.RecommendsShow(collection: @collection)
    $('#container').html(view.render().el)
