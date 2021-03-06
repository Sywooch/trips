#= require views/menu/partition/menu_partition_porter_view
#= require collections/menu_partition_porter_collection
#= require collections/menu_partition_porter_day_entity_collection

_.namespace "App.views"
(->
  App.views.MenuPartitionPortersListView = Backbone.View.extend(
    el: "#partition_porters"
    events:
      "click button.add": "createPorter"
      'keydown input.name': 'processKey',

    initialize: (options) ->
      @porters = App.collections.MenuPartitionPorterCollection
      @name_input = @$el.find('input.name')

    render: ->
      @porters.each (porter) ->
        @renderPorters(porter)
      , this

    renderPorters: (porter) ->
      $body = @$el.find('.body')
      view = new App.views.MenuPartitionPorterView
        renderTo: $body
        model: porter
        days_tabs: $('#menu .nav-tabs')

    createPorter: (e) ->
      e.preventDefault()
      porter = new App.models.MenuPartitionPorterModel
        position: @porters.length + 1
        name: @name_input.val()
      @porters.add porter
      @renderPorters(porter)
      @name_input.val('').focus()

    processKey: (e) ->
      @createPorter(e) if e.which == 13
  )
)()