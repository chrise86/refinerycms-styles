class Style.Views.GamesShow extends Backbone.View

  template: JST['style/templates/games/show']
  resources_template: JST['style/templates/games/show_resources']
  choice_template: JST['style/templates/games/show_choice']

  events:
    "click .next": "next_page"
    "click .pre": "pre_page"
    "click .retry": "reset"
    "click .result": "choice"

  initialize: (options) ->
    @collection.on('reset', @reset, this)

  next_page: (e) ->
    @page += 1
    resource_id = $(e.currentTarget).data("id")
    @choices.push resource_id if resource_id
    if @page < @page_total
      @updateImages()
    else
      @choice(e)
        
    false

  choice: (e) ->
    $.post window.location.pathname+"/choice", choices: @choices, (data) =>
      if data.url
        top.location.href = data.url
      else
        @$("#resources").html(@choice_template(data: data))

    false

  pre_page: (e) ->
    @page -= 1
    @updateImages()

    false

  reset: (e) ->
    @page = 0
    @page_total = @collection.length
    @choices = []
    @updateImages()

  updateImages: ->
    category = @collection.at(@page)
    @$("#resources").html(@resources_template(category: category, page_total: @page_total, page: @page))
    @$("#resources").find(".choice").hover (e) ->
      $('.choice').removeClass('over_choice');
      $(this).addClass('over_choice');

    this

  render: ->
    @$el.html(@template(collection: @collection))
    @reset()

    this